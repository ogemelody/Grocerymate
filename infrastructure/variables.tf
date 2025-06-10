#REGION
variable "AWS_REGION" {
  type    = string
  default = "us-east-1"
}

#VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}


#Internet gateway
variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
}

#AZ and Subnets
variable "azs" {
  description = "Availability Zones to deploy resources in"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
}

#EC2
variable "ec2_ami_id" {
  type    = string
  default = "ami-02b7d5b1e55a7b5f1"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}
variable "ec2_key_name" {
  description = "The name of the EC2 key pair to use"
  type        = string
}


# RDS
variable "db_password" {
  description = "Database password - Postgres"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Database user name"
  type        = string
}

variable "db_name" {
  description = "Database user name"
  type        = string
}

#launch template
variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
  type        = string
}



variable "key_name" {
  description = "Name of the SSH key pair used to access EC2 instances"
  type        = string
}



#s3
variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-grocerystore-bucket" # optional
}


#ASG & ALB
variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  default     = "asg"
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "ec2_name" {
  description = "Tag name for instances"
  type        = string
  default     = "grocerymate-ec2"
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "grocery-alb"
}

variable "target_group_name" {
  description = "Name of the Target Group"
  type        = string
  default     = "alb-tg"
}

variable "target_group_port" {
  description = "Port for the Target Group"
  type        = number
  default     = 5000
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/health"
}