#!/bin/bash
sudo yum update
sudo yum install docker containerd git screen -y
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/libexec/docker/cli-plugins/docker-compose
chmod +x /usr/libexec/docker/cli-plugins/docker-compose

sudo systemctl enable docker.service
sudo service docker start
sudo usermod -a -G docker ec2-user
newgrp docker

aws s3 cp s3://${bucket_name}/config/docker-compose.yml /home/ec2-user/docker-compose.yml
chown ec2-user:ec2-user /home/ec2-user/docker-compose.yml
docker compose -f /home/ec2-user/docker-compose.yml up -d
