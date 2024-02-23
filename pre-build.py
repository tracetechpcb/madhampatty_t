import sys
import uuid
import yaml
from jinja2 import Environment, FileSystemLoader

args = sys.argv # Note: sys.argv[0] is the script name

JWT_SECRET_KEY = str(uuid.uuid4())

'''
    In this block we need to generate docker-cpmpose.yml that will be used by Makefile
'''

with open('./user-config.yaml', 'r') as file:
    user_config = yaml.safe_load(file)

with open('./application-config.yaml', 'r') as file:
    application_config = yaml.safe_load(file)


infrastructure_services = application_config['services']['infrastructure_services']
application_services = application_config['services']['application_services']
volumes = application_config['volumes']

'''
    In this block populate mariadb-service and mongodb-service with enironment variables
'''
for infrastructure_service in infrastructure_services:
    if infrastructure_service['service_name'] == 'mariadb-service':
        infrastructure_service['environment'].update({
            'MYSQL_ROOT_PASSWORD': infrastructure_service['root_password'],
            'MYSQL_DATABASE': infrastructure_service['db_name'],
        })
    if infrastructure_service['service_name'] == 'mongodb-service':
        infrastructure_service['environment'].update({
            'MONGO_INITDB_ROOT_USERNAME': infrastructure_service['root_username'],
            'MONGO_INITDB_ROOT_PASSWORD': infrastructure_service['root_password'],
            'MONGO_INITDB_AUTH_SOURCE': infrastructure_service['auth_source'],  # Specify the authentication database
            'MONGO_INITDB_DATABASE': infrastructure_service['db_name'],
        })

'''
    In this block populate enironment variables for all application services
'''
for application_service in application_services:
    # Set env for authentication-service
    if application_service['service_name'] == 'authentication-service':
        for infrastructure_service in infrastructure_services:
            if infrastructure_service['service_name'] == 'mariadb-service':
                mariadb_root_username = infrastructure_service['root_username']
                mariadb_root_password = infrastructure_service['root_password']
                mariadb_service_name = infrastructure_service['service_name']
                mariadb_service_port = infrastructure_service['service_port']
                mariadb_db_name = infrastructure_service['db_name']

                license_service_environment= {
                    'DOMAIN_NAME': user_config['domain_name'],
                    'JWT_SECRET_KEY': JWT_SECRET_KEY,
                    'MARIADB_DATABASE_URL': f"mysql://{mariadb_root_username}:{mariadb_root_password}@{mariadb_service_name}:{mariadb_service_port}/{mariadb_db_name}",
                    'DEFAULT_APPLICATION_USERNAME': user_config['default_application_username'],
                    'DEFAULT_APPLICATION_PASSWORD': user_config['default_application_password'],
                    'DEFAULT_APPLICATION_EMAIL': user_config['default_application_email'],
                }

                application_service['environment'].update(license_service_environment)

    # Note: For all non authentication application services the below evironment variables are mandatory
    # DOMAIN_NAME: Need to add it as ALLOWED_HOSTS
    # JWT_SECRET_KEY: Needed to decypher jwt tokens
    # MARIADB_DATABASE_URL: Needed to validate the decyphered jwt token info against auth_creds
    # MONGO_DATABASE_URL, MONGODB_DB_NAME: Application Data

    # Set env for license-service
    if application_service['service_name'] == 'license-service':
        for infrastructure_service in infrastructure_services:
            if infrastructure_service['service_name'] == 'mongodb-service':
                mongodb_root_username = infrastructure_service['root_username']
                mongodb_root_password = infrastructure_service['root_password']
                mongodb_service_name = infrastructure_service['service_name']
                mongodb_service_port = infrastructure_service['service_port']
                mongodb_db_name = infrastructure_service['db_name']
                mongodb_auth_source = infrastructure_service['auth_source']

                license_service_environment = {
                    'DOMAIN_NAME': user_config['domain_name'],
                    'JWT_SECRET_KEY': JWT_SECRET_KEY,
                    'MARIADB_DATABASE_URL': license_service_environment['MARIADB_DATABASE_URL'],
                    'MONGODB_DATABASE_URL': f"mongodb://{mongodb_root_username}:{mongodb_root_password}@{mongodb_service_name}:{mongodb_service_port}/{mongodb_db_name}?authSource={mongodb_auth_source}",
                    'MONGODB_DB_NAME': mongodb_db_name,
                    'LICENSE_KEY': user_config['license_key'],
                }

                application_service['environment'].update(license_service_environment)


env = Environment(loader=FileSystemLoader('.'))
template = env.get_template('./docker_compose_template.j2')

final_docker_compose_conf = template.render(infrastructure_services=infrastructure_services, application_services=application_services, volumes=volumes)

with open('./docker-compose.yml', 'w') as f:
    f.write(final_docker_compose_conf)
