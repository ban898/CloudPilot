import requests
import subprocess

# Get the public IP of the EC2 instance
response = requests.get('http://169.254.169.254/latest/meta-data/public-ipv4')
public_ip = response.text

# Command to modify the GitLab configuration file inside the container
modify_config_cmd = [
    'docker', 
    'exec', 
    'ubuntu_web_1', 
    'sed', 
    '-i', 
    f's|^external_url.*$|external_url "http://{public_ip}/"|', 
    '/etc/gitlab/gitlab.rb'
]

# Modify the GitLab configuration file inside the container
subprocess.run(modify_config_cmd)

# Restart the GitLab container for changes to take effect
subprocess.run(['docker', 'restart', 'ubuntu_web_1'])

print('GitLab configuration updated successfully.')


