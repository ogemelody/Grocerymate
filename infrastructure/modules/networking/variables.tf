#VPC
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name for the VPC"
  type        = string
}



variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}


# Availability Zones
variable "azs" {
  description = "List of Availability Zones to use"
  type        = list(string)
}

# Public Subnets
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

# Private Subnets
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "db_port" {
  type    = number
  default = 5432
}
