provider "aws" {
  region = "eu-central-1"
}


#1. Create VPC
#2. Create Internet gateway
#3. Create Route Tables
#   Elastic IP for NAT Gateway - no need use ELB DNS name instead
#   NAT Gateway (for private subnet internet access)
#   Create Private Subnet - Database and Public Subnets -EC2
#   Associate subnet with Route Table. Question (I saw this online but I did not understand why)- I think to atach the subnets to route table
#   Create EC2
#   Create Security Groups with Inbound rules - 22,80, 5000,5432
#   Create RDS
#Question
#1. FOR  cidr_block = "10.0.0.0/16" can I just change the value and it is ok like "10.4.6.0/16"?
#2. For route table I only gave 0.0.0.0/0 internet access do i have to add 5000?
# I had issues adding  route {
#    ipv6_cidr_block        = "::/0"
#    egress_only_gateway_id = aws_internet_gateway.gw.id
#  }
# to my route table is it not important?


# ----------------CREATING RESOURCES ------------

#   Resource: VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "grocery-app_vpc"
  }
}

#2. Create Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "grocery-mate-igw"
  }
}


#3. Create custom Route Table
resource "aws_route_table" "grocery-mate-route-table" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Grocery-store-route-table"
  }
}
# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "private-route-table"
  }
}

#Elastic IP for NAT Gateway - for the EC2 LIKE entry point - no need for this since you will have ELB with DNS name
#resource "aws_eip" "nat_eip" {
#  domain = "vpc"

 # tags = {
#    Name = "app_nat_eip"
 # }
#}

# Resource: Private Subnet - Database and Public Subnets -EC2
#public
resource "aws_subnet" "subnet1_app" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "public-subnet1-app"
  }
}

#private
resource "aws_subnet" "subnet2_app" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "private-subnet2-app"
  }
}

resource "aws_subnet" "subnet3_app" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-central-1c"

  tags = {
    Name = "private-subnet3-app"
  }
}
# NAT Gateway (for private subnet internet access)
#resource "aws_nat_gateway" "nat" {
 # allocation_id = aws_eip.nat_eip.id
 # subnet_id     = aws_subnet.subnet1_app.id  # Must be in a public subnet -Question. I saw this online not sure why it is not subnet 2?

 # tags = {
#    Name = "app_nat_gw"
#}
#}

#RESOURCE : ASSOCIATION OF route tables
# Associate Public Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.subnet1_app.id
  route_table_id = aws_route_table.grocery-mate-route-table.id
}
# Associate Private Route Table
resource "aws_route_table_association" "private_assoc1" {
  subnet_id      = aws_subnet.subnet2_app.id
  route_table_id = aws_route_table.private_rt.id

}

resource "aws_route_table_association" "private_assoc2" {
  subnet_id      = aws_subnet.subnet3_app.id
  route_table_id = aws_route_table.private_rt.id

}

#RESOURCE: EC2
resource "aws_instance" "grocery-mate-server" {
  ami           = "ami-02b7d5b1e55a7b5f1"
  instance_type = "t3.micro"
  subnet_id                   = aws_subnet.subnet1_app.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = "Grocerymate_key_pair"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "grocery-mate-server"
   }
}

#RESOURCE:SECURITY GROUP

#security group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.app_vpc.id
  ingress {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Change to your IP for security
    }

  ingress {
      description = "internet"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Change to your IP for security
    }

  ingress {
      description = "database"
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Change to your IP for security
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "ec2_sg"
    }
}

#security group for DB
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow POSTGRESQL"
  vpc_id      = aws_vpc.app_vpc.id


  ingress {
    description = "database"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]

  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "db_sg"
  }
}

#RESOURCE: RDS POSTGRESQL

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.subnet2_app.id,  # e.g., eu-central-1a
    aws_subnet.subnet3_app.id   # e.g., eu-central-1b
  ]

  tags = {
    Name = "rds_subnet_group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "app-db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = "grocerystoredb"
  username                = "melody"
  password                = "Egwuchukwu_13" # replace with a secret manager
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  publicly_accessible     = false
  skip_final_snapshot     = true
  availability_zone       = "eu-central-1b"
  multi_az                = false

  tags = {
    Name = "PostgreSQL RDS"
  }
}