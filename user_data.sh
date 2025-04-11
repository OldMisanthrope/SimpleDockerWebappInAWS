#!/bin/bash

########## Server configuration and software installation ##########

# Updating packages and installing dependencies
echo "Starting update and installing dependencies" > /var/log/user-data.log
apt-get update >> /var/log/user-data.log 2>&1
apt-get -y upgrade >> /var/log/user-data.log 2>&1
apt-get -y install apt-transport-https ca-certificates curl software-properties-common >> /var/log/user-data.log 2>&1

# Adding an official Docker GPG key
echo "Adding Docker's official GPG key" >> /var/log/user-data.log
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg >> /var/log/user-data.log 2>&1

# Adding a Docker repository
echo "Adding Docker repository" >> /var/log/user-data.log
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null >> /var/log/user-data.log 2>&1

# Installing Docker
echo "Installing Docker" >> /var/log/user-data.log
apt-get update >> /var/log/user-data.log 2>&1
apt-get -y install docker-ce docker-ce-cli containerd.io >> /var/log/user-data.log 2>&1

# Installing Docker Compose (if required)
echo "Installing Docker Compose" >> /var/log/user-data.log
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose >> /var/log/user-data.log 2>&1
chmod +x /usr/local/bin/docker-compose >> /var/log/user-data.log 2>&1

# Starting a Docker service
echo "Starting Docker service..." >> /var/log/user-data.log
systemctl start docker >> /var/log/user-data.log 2>&1
systemctl enable docker >> /var/log/user-data.log 2>&1

# Verifying Docker installation
echo "Docker version:" >> /var/log/user-data.log
docker --version >> /var/log/user-data.log 2>&1


################### Launch application #########################

# Starting the Nginx container on port 80
echo "Running Nginx Docker container on port 80" >> /var/log/user-data.log
docker run -d -p 80:80 --name nginx-container nginx >> /var/log/user-data.log 2>&1


################### Application verification #########################

# Checking container status
echo "Docker container status:" >> /var/log/user-data.log
docker ps >> /var/log/user-data.log 2>&1

# Checking port 80
echo "Checking if port 80 is open..." >> /var/log/user-data.log
netstat -tuln | grep :80 >> /var/log/user-data.log 2>&1

