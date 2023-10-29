After the creation of the instance I SSH into the gitlab instance downloaded docker compose

# 1. docker-compose.yaml -
 thats the file I used to create the container in the instance, i decided to attach volumes from the container directlly do the ebs volume of the ec2, soo there will be an easier way to see logs, add configurations and so on.

# 2. external_ip_script.py -
 A Python script which fetches the ec2 public ip and insert it into the container into the gitlab.rb file. so I will not need to do it manually every time.

