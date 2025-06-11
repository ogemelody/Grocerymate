#VPC
output "vpc_id" {
  value = aws_vpc.grocery-app-vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.grocery-app-vpc.cidr_block
}

#IGW
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

#Route Table
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}

#Subnets
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

#Security Group
output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

#sg - alb
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

#sg- asg
output "asg_sg_id" {
  value = aws_security_group.asg_sg.id
}