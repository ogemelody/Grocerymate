

module "networking" {
  source = "./modules/networking"

  # VPC
  cidr_block = var.vpc_cidr_block
  vpc_name   = var.vpc_name

  # Subnets
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  # Internet Gateway
  igw_name = var.igw_name


}
#   Create EC2
module "ec2" {
  source            = "./modules/EC2"
  ec2_ami_id        = var.ec2_ami_id
  ec2_instance_type = var.ec2_instance_type
  subnet_id         = element(module.networking.public_subnet_ids, 0) # example: first public subnet
  security_group_id = module.networking.ec2_sg_id

  instance_name = "${var.vpc_name}-app-server"
}

#3. Create Route Tables
#   Elastic IP for NAT Gateway - no need use ELB DNS name instead because my Database is not receiving anything from the internet
#   NAT Gateway (for private subnet internet access)

#   Associate subnet with Route Table.


#   Create Security Groups with Inbound rules - 22,80, 5000,5432
#   Create RDS + IAM

#   Create S3 Bucket

#create secrets
module "secrets_manager" {
  source      = "./modules/secrets_manager"
  db_password = var.db_password

}

#create RDS
module "rds_postgres_db" {
  source            = "./modules/rds_postgres_db"
  db_name           = var.db_name
  db_username       = var.db_username
  subnet_ids        = module.networking.private_subnet_ids
  security_group_id = module.networking.db_sg_id
  secret_arn = module.secrets_manager.secret_arn
}
