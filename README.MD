# Project Structure Overview

The project is structured to implement Infrastructure as Code (IaaC) as much as possible, ensuring clarity and ease of understanding.
The project has EKS cluster with 2 nodes 1 for Jenkins Master and 1 for the Jenkins Agent, outside of the cluster it has EC2 instance with self-hosted GitLab 


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

