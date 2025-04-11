# Basic High Availability (HA) Environment for Docker Applications

## Description

This project demonstrates how to set up a High Availability (HA) environment on **AWS** using **Terraform**. The infrastructure provisions an **EC2 instance** with Docker installed and sets up an **Elastic Load Balancer (ELB)** along with **Auto Scaling Groups (ASG)** for high availability. Once the environment is set up, you can deploy any Docker-based application on the instance, with **Nginx** being used as an example application in this setup.

The focus of this project is on automating infrastructure provisioning with **Terraform**, which simplifies the creation of necessary AWS resources such as EC2 instances, security groups, Auto Scaling Groups, and Load Balancers.

### Key Features
- **Terraform** is used for provisioning the entire AWS infrastructure.
- **Elastic Load Balancer (ELB)** distributes incoming HTTP traffic across multiple EC2 instances to ensure fault tolerance.
- **Auto Scaling Groups (ASG)** automatically scale EC2 instances to maintain the required number of healthy instances.
- **Docker** is used to run applications in containers, with **Nginx** as an example.
- **Automated Setup** using a `user-data.sh` script for configuring the EC2 instance to run Docker and Nginx.
- Output the **DNS name** of the Load Balancer to access your application via the web.

### What This Setup Includes:
- **Terraform Configuration**: Terraform is used to set up AWS infrastructure, including EC2 instances, ELB, ASG, and security groups.
- **Auto Scaling**: The **Auto Scaling Group** ensures that the appropriate number of EC2 instances are running, scaling up or down based on demand.
- **Elastic Load Balancer (ELB)**: ELB distributes incoming traffic across all healthy instances to ensure high availability.
- **Docker Setup**: Docker is installed and configured to run any containerized application, with Nginx being an example in this case.

## Prerequisites

To use this setup, ensure you have the following:
- **Terraform** installed on your machine.
- **AWS CLI** configured with proper credentials to deploy infrastructure on AWS.
- An **AWS Account** for deploying resources.

## Setup

### 1. Terraform Configuration
Terraform is used to provision the infrastructure. The configuration includes:
- **Subnets**: The project uses **default subnets** from the availability zones available in the region. Subnet data is fetched dynamically using the `data "aws_availability_zones" "available_az"` resource.
- **EC2 Instances**: EC2 instances are provisioned and configured with the `user-data.sh` script, which installs Docker and sets up the application container (Nginx) to run on port 80.
- **Security Groups**: The necessary security groups are created to allow inbound traffic on port 80 for HTTP requests to the application.
- **Elastic Load Balancer (ELB)**: The **ELB** distributes incoming traffic across the EC2 instances to ensure fault tolerance and high availability.
- **Auto Scaling Group (ASG)**: The **ASG** ensures that there are always at least two healthy EC2 instances running, distributing traffic between them via the ELB.

### 2. Running Docker and Nginx Container
Once the EC2 instance is launched:
- **Docker** is installed and configured to run containers.
- An **Nginx** container is pulled from the Docker registry and runs on port **80**. You can modify the `user-data.sh` script to run any other Docker-based application.

### 3. Elastic Load Balancer and Auto Scaling
- **Elastic Load Balancer (ELB)** is configured to distribute incoming HTTP traffic to healthy EC2 instances. The ELB ensures that traffic is balanced across all instances and that if one instance fails, traffic will be directed to healthy instances.
- **Auto Scaling Groups (ASG)** are configured to maintain a minimum of two healthy instances running. The ASG automatically adjusts the number of instances based on traffic load, ensuring that your application can handle varying levels of demand.

## Usage

1. **Launch EC2 Instance**:
   - Use **Terraform** to provision the EC2 instance and deploy the required infrastructure. Terraform will create all the necessary resources, including subnets, security groups, ELB, and Auto Scaling Group.
   
2. **Access the Application**:
   - Once the infrastructure is provisioned, Terraform will output the **DNS name** of the **Elastic Load Balancer (ELB)**. You can access your application by visiting the URL provided in the output.
   - The URL will point to the Nginx container running on port 80, displaying the default **Nginx** welcome page or your custom application.

3. **Modify Nginx Content**:
   - To change the content served by Nginx, you can modify the `index.html` file inside the Docker container, or replace the Nginx image with another application in the `user-data.sh` script.

4. **Scaling**:
   - **Auto Scaling** is configured to automatically adjust the number of EC2 instances based on traffic. You can modify the **Auto Scaling Group** settings in Terraform to increase or decrease the number of instances or set custom scaling policies.

## Notes

- **Port 80** is used for HTTP traffic, and the application is accessible via the web through the **DNS name** of the ELB.
- The **`user-data.sh`** script automates the process of setting up Docker, pulling the container image, and running it.
- This setup is flexible and can be easily modified to run any Dockerized application by adjusting the `user-data.sh` script.
- The use of **Auto Scaling Groups** and **Elastic Load Balancer** ensures that the application remains highly available and can handle traffic spikes.

## License