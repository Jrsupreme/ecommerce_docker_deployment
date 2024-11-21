Ecommerce Docker Deployment
Purpose
The purpose of this workload is to demonstrate the deployment of a highly available, containerized e-commerce application on AWS using Terraform, Docker, and Jenkins. This includes creating a custom VPC with private and public subnets, deploying backend and frontend services using Docker containers, and managing infrastructure with a CI/CD pipeline configured in Jenkins.

2. Infrastructure Setup with Terraform
Custom VPC: Configured a custom VPC in us-east-1 with:
2 Availability Zones (us-east-1a and us-east-1b).
Public and private subnets in each AZ.
EC2 Instances:
Bastion hosts in the public subnets for secure access to private instances.
Application servers in private subnets for backend and frontend containers.
RDS Database: Deployed an Amazon RDS instance to handle application data.
Load Balancer: Configured an Application Load Balancer to route traffic to backend instances.

3. Jenkins Manager
Launched a t3.micro EC2 instance named Jenkins.
Installed Java 17 and Jenkins.
Opened port 8080 in the security group for Jenkins access.
Installed:
Java 17
Terraform
Docker

Connected this instance as a node in Jenkins using the following steps:
Accessed Jenkins Dashboard → Build Executor Status → New Node.
Created a node named build-node and configured it to launch via SSH.
Added credentials for SSH using the private key from the .pem file.
Verification:

Ensured build-node appeared as "Connected and Online" in Jenkins.

