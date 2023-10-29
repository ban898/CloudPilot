# 1. sg.tf - 
After my cluster got created I created a security group for my GitLab ec2 instance so it will allow outgoing connection and incoming internet connection on speceific ports 

# 2.  main.tf -
 Here i created the "extra" resources I needed a key pair for the instance, the instance itself and associated the security group i created before with this instance.
