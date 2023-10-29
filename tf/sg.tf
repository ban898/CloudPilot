resource "aws_security_group" "my_sg" {
  name        = "my-sg"
  description = "Security Group for GitLab EC2 instance"
  vpc_id      = "vpc-08d135fe892e66aba"  
}

resource "aws_security_group_rule" "ssh_from_all_ips" {
  description        = "Allow SSH from all IPs"
  type               = "ingress"
  from_port          = 22
  to_port            = 22
  protocol           = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.my_sg.id 
}

resource "aws_security_group_rule" "http_from_all_ips" {
  description        = "HTTP"
  type               = "ingress"
  from_port          = 80
  to_port            = 80
  protocol           = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.my_sg.id
}

resource "aws_security_group_rule" "https_from_all_ips" {
  description        = "HTTPS"
  type               = "ingress"
  from_port          = 443
  to_port            = 443
  protocol           = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.my_sg.id
}

resource "aws_security_group_rule" "all_outbound" {
  description        = "Allow all outbound traffic"
  type               = "egress"
  from_port          = 0
  to_port            = 0
  protocol           = "-1"   # This allows all protocols
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id  = aws_security_group.my_sg.id
}


