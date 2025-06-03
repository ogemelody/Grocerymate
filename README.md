# Guide: Cloud Deployment of the Grocerymate App with AWS, Terraform, and Docker


## 📖 Table of Contents
- [🏁 Introduction](#-introduction)
- [🏗️ Infrastructure Overview](#-infrastructure-overview) 
- [🏛️ Architecture Diagrams](#-architecture-diagrams)
- [🛠️ Terraform Configuration](#-terraform-configuration)
- [[🏗️ Infrastructure Components](#-infrastructure-components)



---
## 🏁 Introduction
The Grocerymate App deployment on cloud is a project from my Cloud Engineering Training from Masterschool.
The application was originally developed by **Alejandro Román**, our Track Mentor (huge thanks to him!). 
My task and focus was to design and deploy its **AWS infrastructure step by step**, implementing each component individually.  

Instead of setting up resource via the console , I used Terraform for full provisioning and deployment of AWS resources, which ensures a **scalable, repeatable, and error-resistant deployment process**, 
eliminating the need for manual configurations.  

For details about the **application's features, functionality, and local installation**, refer to the original [`README.md`](Application.md) by Alejandro.  

This document focuses exclusively on the **AWS infrastructure, deployment process, and automation**.

---
## 🏗️ Infrastructure Overview

This modularized Terraform configuration provisions the infrastructure for a grocery web application using AWS.
The setup includes:
- An auto-scalable high-available Multi-AZ EC2 environment running Dockerized applications.
- A secure PostgreSQL database on RDS with multiple availabilty in 3 private subnets.
- A Multi_AZ Application Load Balancer for traffic distribution.
- An S3 bucket for storing user avatars and database dumps.

The infrastructure is designed for **high availability, scalability, and security**.

---
## 🏛️  Architecture Diagrams
**Resource Overview** 
![Resources](Assets/Cloud_Grocery_app.jpg)

**VPC Routing**
![Resources](Assets/VPC_Routing.jpg)

---
## 🛠️ Terraform configuration
Used the main.tf in creating all the AWS resources.

---
## 🏢 Infrastructure Components

### **1. 🌐 Virtual Private Cloud (VPC)**
- **Subnets:** 3 Public (for ALB, EC2) & 3 Private (for RDS).
- **Internet Gateway:** Provides internet access to public subnets.
- **Route Table**: Configured for public subnets routing.
- **VPC Endpoint Gateway:** Provides access to S3 bucket over AWS network.

### **2. 🔐 Security Groups**
- ALB security group allows ports 80.
- EC2 security group allows SSH from a specific IP and ALB traffic over port 5000.
- RDS security group allows access only from EC2 instances.
- ASG security group allows ports 22 for SSH access to EC2 instance.

### **3. 🖥️ Compute Infrastructure (EC2 & Auto Scaling Group)**
- **Auto Scaling Group (ASG)**:
  - Uses a **Launch Template** with user_data for EC2 configuration.
  - Deploys EC2 instances in public subnets.
  - **Scaling Settings**(adjustable as needed):
- **add Docker**

### **4. ⚖️ Application Load Balancer (ALB)**
- Distributes incoming traffic across EC2 instances via Target Group.
- Listens on port 80.
- Health check path: `/health`

### **5. 🗄️ Database (Amazon RDS - PostgreSQL)**
- **Instance Type:** `db.t3.micro` (free-tier eligible).
- **Multi-AZ Deployment:** Enabled.
- **Security:** Deployed in a **private subnet** with restricted access.

### **7. 🗂️ Storage (S3 Bucket)**
- **Purpose**: Stores user avatar images, db_dump and layer files
- **Configuration**:
  - **Bucket Name**: Set via Terraform variables.
  - **Versioning**: Disabled.
  - **Lifecycle Policy**: Disabled.
  - **Public Access Control**:
    - Block Public ACLs: Disabled.
    - Block Public Policy: Disabled.
  - **Preloaded Avatar**: `user_default.png` is uploaded.
  - **Preloaded db_dump file**: `sqlite_dump_clean.sql` is uploaded

### **8. 🎭 IAM Roles & Policies**
- **EC2 Role:** Allows EC2 accessing S3.





