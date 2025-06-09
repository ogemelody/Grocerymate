#VPC
output "vpc_id" {
  value = module.networking.vpc_id
}

output "vpc_cidr_block" {
  value = module.networking.vpc_cidr_block
}

#Internet Gateway
output "igw_id" {
  value = module.networking.igw_id
}

# RDS variables.tf
variable "secret_arn" {
  description = "ARN of the secret storing DB password"
  type        = string
}
