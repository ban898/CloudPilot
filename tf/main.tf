resource "aws_key_pair" "gitlab_key" {
  key_name   = "gitlab_key"
  public_key = file("~/.ssh/gitlab_key.pub")  
}

provider "aws" {
  region = "us-east-1"  
}

resource "aws_instance" "gitlab_instance" {
  ami             = "ami-0261755bbcb8c4a84"  
  instance_type   = "t3.xlarge"
  subnet_id       = "subnet-0004301097f4a76da"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name = "gitlab_key"  

  root_block_device {
    volume_type = "gp2"
    volume_size = 30  
  }

  tags = {
    Name  = "GitLab Instance"
    work  = "gitlab"
  }
}

resource "aws_instance" "deploy_instance" {
  ami             = "ami-0261755bbcb8c4a84"  
  instance_type   = "t3.xlarge"
  subnet_id       = "subnet-0004301097f4a76da"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name = "gitlab_key"  

  root_block_device {
    volume_type = "gp2"
    volume_size = 30  
  }

  tags = {
    Name  = "Deploy Instance"
    work  = "deploy"
  }
}

output "gitlab_instance_public_ip" {
  value = aws_instance.gitlab_instance.public_ip
}

output "deploy_instance_public_ip" {
  value = aws_instance.deploy_instance.public_ip
}

