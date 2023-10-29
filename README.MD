# Project Overview

This project is structured around Infrastructure as Code (IaaC) principles, ensuring clarity and ease of understanding. The key components of this project include:

- An EKS cluster with two nodes: one for Jenkins Master and one for the Jenkins Agent.
- An EC2 instance serving as a self-hosted GitLab.
- Another EC2 instance for deployment purposes.

## Setup Steps

Here's a summary of the setup steps and actions taken:

1. **Creating the EKS Cluster:**

   - Created the EKS cluster using `eksctl` with a configuration file `cluster.yaml`.
   - Initialized Terraform with `terraform init`.
   - Applied Terraform configurations with `terraform apply`.

2. **Setting Up GitLab:**

   - SSHed into one of the EC2 nodes (GITLAB).
   - Installed Docker and Docker Compose.
   - Ran the GitLab container using a Docker Compose file.
   - Created a script to retrieve the public IP of the instance and assign it to the GitLab configuration file.
   - Created a systemd service called `gitlab-config.service` to run the script on boot.

   Systemd Service Configuration (`gitlab-config.service`):
   ```ini
   [Unit]
   Description=Update GitLab Configuration
   After=network.target

   [Service]
   ExecStart=/usr/bin/python3 /home/ubuntu/external_ip.py
   WorkingDirectory=/home/ubuntu
   Restart=no

   [Install]
   WantedBy=multi-user.target
   ```
Then i signed to the root acc, created a non root user, approved it and created a repository , craeted a PAT and cloned the repository to my persnoal Laptop
git clone http://44.201.4.72/ban898/project.git to a folder on my personal

Created the devops NS , installed jenkins Helm Chart and CSI driver:
kubectl apply -f devops-ns.yaml 
helm repo add jenkins https://charts.jenkins.io
helm repo update
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=master"

Added the following policies : 
AmazonEBSCSIDriverPolicy
AmazonEC2FullAccess
attached them both to the relevant role 

Installed another Helm chart for ingress but more customized
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace kube-system --create-namespace
jenkins-ingress.yaml 
kubectl apply -f jenkins-ingress.yaml

Retrived the DNS of the ELB:
kubectl get svc -n kube-system | grep ingress-nginx-controller
Added an ingress security rule on port 8080 (to the ELB SG)

logged in to jenkins, Installed required Plugins git gitlab kubernetes Credentials
Added gitlab token
created a job of type pipeline named it Elta-test (retrived the job end point for GitLab Integrations)

in Gitlab Integrations I configured a jenkins Integration with the relevant webhook
Tested the connection and approved it

Logged in to the Deploy instance installed docker (same as i did before)

Created a Jenkinsfile which will checkout, build, push and deploy with the right configuration and variables.
Pushed a Jenkinsfile and the dockerfile to the repository and triggered a job








The breakdown of the directories and their purposes is as follows:

## 1. EKSCTL Directory (`eksctl`)

- **Purpose:** To set up our Kubernetes cluster.
- **Reasoning:** Using `eksctl` simplifies the creation of an EKS cluster and naturally implements IaaC, eliminating many complications that might arise if using Terraform alone for this task.

## 2. Terraform Directory (`tf`)

- **Purpose:** To handle configurations beyond the capabilities of `eksctl`.
- **Reasoning:** Terraform provides a robust IaaC approach and is used to cover additional configurations not handled by `eksctl`.

## 3. EC2-GitLab Directory (`ec2-gitlab`)

- **Purpose:** Contains all scripts and configuration files associated with the GitLab instance.
- **Note:** This setup includes a self-hosted container of GitLab CE on an EC2 instance outside of the Kubernetes cluster.

## 4. Kubernetes Directory (`k8s`)

- **Purpose:** Houses most Kubernetes objects necessary for the project.
  
### Helm Sub-directory (`Helm`)
  
- **Purpose:** Contains files pertinent to helm charts.
- **Reasoning:** Helm assists in managing Kubernetes applications through the use of Helm Charts.

## 5. Policy Directory (`policy`)

- **Purpose:** Manages custom policies.
- **Reasoning:** A manual policy was created and attached to an EKS role to facilitate the provisioning of an EBS volume.

## 6. ELTA Directory (`elta`)

- **Purpose:** Acts as the Source Code Management (SCM) in the project.
- **Contents:** A .NET Core web app created from its default template.
- **Integration:** The app is stored in a repository on the GitLab instance. Events in this directory are configured to trigger the Jenkins pipeline.

