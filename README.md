Ecommerce Docker Deployment
Purpose
The purpose of this workload is to demonstrate the deployment of a highly available, containerized e-commerce application on AWS using Terraform, Docker, and Jenkins. This includes creating a custom VPC with private and public subnets, deploying backend and frontend services using Docker containers, and managing infrastructure with a CI/CD pipeline configured in Jenkins.

1. Infrastructure Setup with Terraform
Custom VPC: Configured a custom VPC in us-east-1 with:
2 Availability Zones (us-east-1a and us-east-1b).
Public and private subnets in each AZ.
Infrastructure Components
The following infrastructure was built using Terraform, organized into separate modules for maintainability and reusability:

1. Application Load Balancer (ALB)
Purpose: Distributes incoming traffic to backend instances for high availability.
Files Used:
main.tf: Contains the resource block for the ALB, target groups, and listener configurations.
variables.tf: Defines input variables such as ALB name, listener ports, and security group settings.
2. Database (DB)
Purpose: Hosts the application's relational data using an Amazon RDS instance.
Files Used:
main.tf: Defines the RDS instance, parameter group, and associated security groups.
variables.tf: Contains variables for database engine, version, username, and instance type.
3. EC2 Instances
Purpose: Hosts the frontend and backend application components.
Files Used:
main.tf: Defines the EC2 instances, AMI, instance type, security groups, and user data for Docker setup.
outputs.tf: Outputs the public IP addresses of the instances for reference.
variables.tf: Contains instance-specific variables such as AMI ID, key pair, and instance size.
4. Virtual Private Cloud (VPC)
Purpose: Provides a custom networking environment for the application, including public and private subnets.
Files Used:
main.tf: Configures the VPC, subnets, NAT gateways, route tables, and internet gateway.
outputs.tf: Outputs details such as VPC ID, subnet IDs, and NAT gateway IPs.
variables.tf: Defines variables for CIDR blocks, subnet configurations, and availability zones.

2. Jenkins Manager
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

