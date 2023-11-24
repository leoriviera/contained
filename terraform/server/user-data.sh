#!/bin/bash
sudo yum update
sudo yum install docker -y
sudo systemctl enable docker.service
sudo service docker start
sudo usermod -a -G docker ec2-user
newgrp docker
docker run --pull always --restart always --platform linux/amd64 -v /var/run/docker.sock:/var/run/docker.sock -p 3000:3000 -d ghcr.io/leoriviera/contained-server:latest
