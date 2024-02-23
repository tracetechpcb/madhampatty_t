import subprocess

# Cleanup all the files once they are copied to the image
subprocess.run(['rm', "./nginx-service/signed.crt"], check=False)
subprocess.run(['rm', "./nginx-service/signed.key"], check=False)
subprocess.run(['rm', "./nginx-service/nginx.conf"], check=False)