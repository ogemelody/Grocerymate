variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use"
  type        = string
}

variable "security_group_id" {
  description = "Security group to attach to the EC2 instance"
  type        = string
}

variable "name" {
  description = "Tag name for the instance"
  type        = string
}
