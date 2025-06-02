#!/bin/bash

# Update all packages
yum update -y

# Install essential software
amazon-linux-extras enable postgresql15
yum clean metadata
yum install -y git python3 python3-pip postgresql15 postgresql15-server postgresql15-contrib

# Clone your application repo
git clone https://github.com/ogemelody/Grocerymate.git

# Install Python requirements if applicable
pip3 install -r /home/ec2-user/app/requirements.txt

echo "EC2 instance configured successfully" > /home/ec2-user/setup_status.txt
