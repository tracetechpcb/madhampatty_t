import os
import sys
import yaml
import subprocess
from jinja2 import Environment, FileSystemLoader

args = sys.argv # Note: sys.argv[0] is the script name


'''
    In this block we generate Self-Signed certificates. If user gives their own certificates,
    then we copy them to a location for the Dockerfile to later copy to image
'''

with open('./user-config.yaml', 'r') as file:
    config = yaml.safe_load(file)

domain_name = config["domain_name"]
if domain_name is not None and domain_name.strip():
    print(f"domain_name identified as {domain_name}")
else:
    print("domain_name not set")
    exit(1)


cert_file_path = config["ssl_certificate_path"]
key_file_path = config["ssl_certificate_key_path"]
if (cert_file_path is not None and cert_file_path.strip()) and (key_file_path is not None and key_file_path.strip()):
    try:
        subprocess.run(['cp', cert_file_path, "./nginx-service/signed.crt"], check=True)
        subprocess.run(['cp', key_file_path, "./nginx-service/signed.key"], check=True)
    except subprocess.CalledProcessError:
        print('Could not copy given ssl vertificate and/or key')
        exit(1)
else:
    openssl_command = f"openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout './nginx-service/signed.key' -out './nginx-service/signed.crt' -subj '/C=US/ST=YourState/L=YourCity/O=YourOrganization/OU=YourUnit/CN={domain_name}'"
    try:
        subprocess.run(openssl_command, shell=True, check=True)
    except subprocess.CalledProcessError:
        print('Failed to generate self-signed vertificate')
        exit(1)

'''
    In this block we need to generate nginx config and put it in a location so Docker can copy to image
'''
with open('./application-config.yaml', 'r') as file:
    config = yaml.safe_load(file)

services = []

application_services = config['services']['application_services']
for service in application_services:
    path = service["api"]
    proxy_pass = f"http://{service['nginx_upstream']}"
    services.append({
        'name': service['service_name'],
        'port': service['service_port'],
        'upstream': service['nginx_upstream'],
        'path': path,
        'proxy_pass': proxy_pass
    })


env = Environment(loader=FileSystemLoader('.'))
template = env.get_template('./nginx-service/nginx_conf_template.j2')

# Render the template with domain name and APIs
final_nginx_conf = template.render(domain_name=domain_name, services=services)

with open('./nginx-service/nginx.conf', 'w') as f:
    f.write(final_nginx_conf)
