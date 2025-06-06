#VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

#Internet Gateway
output "igw_id" {
  value = module.internet_gateway.igw_id
}
