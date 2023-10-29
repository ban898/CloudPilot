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
## GitLab Setup

1. **Create a Non-Root User and Repository:**

   - Signed in to the root account on the EC2 GitLab instance.
   - Created a non-root user.
   - Approved the user and created a GitLab repository.
   - Generated a Personal Access Token (PAT).
   - Cloned the repository to your personal laptop using the following command:

     ```bash
     git clone http://44.201.4.72/ban898/project.git
     ```

   - Saved the cloned repository to a folder on your laptop.

2. **Create the DevOps Namespace and Install Jenkins Helm Chart and CSI Driver:**

   - Applied the Kubernetes namespace configuration using:

     ```bash
     kubectl apply -f devops-ns.yaml
     ```

   - Added the Jenkins Helm Chart repository:

     ```bash
     helm repo add jenkins https://charts.jenkins.io
     ```

   - Updated the Helm repositories:

     ```bash
     helm repo update
     ```

   - Installed the AWS EBS CSI driver for storage provisioning using:

     ```bash
     kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=master"
     ```

3. **Configure AWS Policies:**

   - Added and attached the following policies to the relevant IAM role:

     - AmazonEBSCSIDriverPolicy
     - AmazonEC2FullAccess

4. **Install a Customized Ingress Controller:**

   - Added the Helm chart repository for ingress-nginx:

     ```bash
     helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
     ```

   - Updated the Helm repositories:

     ```bash
     helm repo update
     ```

   - Installed the customized ingress-nginx Helm chart into the `kube-system` namespace and created the namespace if it doesn't exist:

     ```bash
     helm install nginx-ingress ingress-nginx/ingress-nginx --namespace kube-system --create-namespace
     ```

   - Applied the `jenkins-ingress.yaml` configuration:

     ```bash
     kubectl apply -f jenkins-ingress.yaml
     ```

5. **Retrieve the DNS of the ELB:**

   - Retrieved the DNS of the Elastic Load Balancer (ELB) using:

     ```bash
     kubectl get svc -n kube-system | grep ingress-nginx-controller
     ```

   - Added an ingress security rule on port 8080 to the ELB Security Group.

## Jenkins Configuration

6. **Login to Jenkins and Install Required Plugins:**

   - Logged in to Jenkins.
   - Installed the required plugins: git, gitlab, kubernetes, and Credentials.

7. **Add GitLab Token:**

   - Added a GitLab token to Jenkins for integration purposes.

8. **Create a Pipeline Job:**

   - Created a job of type pipeline named "Elta-test."
   - Retrieved the job endpoint for GitLab Integrations.

9. **Configure GitLab Integration:**

   - Configured a Jenkins Integration in GitLab with the relevant webhook.
   - Tested the connection and approved it.

## Deploy Instance

10. **Login to the Deploy Instance and Install Docker:**

    - Logged in to the deploy instance.
    - Installed Docker (same as previously).

11. **Create a Jenkinsfile for Pipeline:**

    - Created a Jenkinsfile that checks out, builds, pushes, and deploys with the correct configuration and variables.

12. **Push Jenkinsfile and Dockerfile:**

    - Pushed the Jenkinsfile and the Dockerfile to the GitLab repository.
    - Triggered the Jenkins job to initiate the pipeline.








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
