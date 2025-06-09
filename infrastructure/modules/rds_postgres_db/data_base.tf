data "aws_secretsmanager_secret" "db_password" {
 name = "dev/postgres/password"
}

data "aws_secretsmanager_secret_version" "db_password_version" {
 secret_id = data.aws_secretsmanager_secret.db_password.id
}



resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
   Name = "RDS Subnet Group"
  }
}

resource "aws_db_instance" "primary" {
  identifier             = "${replace(lower(var.db_name), "_", "-")}-primary"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.security_group_id]
  db_name                = var.db_name
  username               = var.db_username
  password               = data.aws_secretsmanager_secret_version.db_password_version.secret_string
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = true
  availability_zone      = null # AWS picks one automatically for primary
  tags = {
    Name = "Primary PostgreSQL"
  }
}

resource "aws_db_instance" "read_replica_1" {
  identifier              = "${replace(lower(var.db_name), "_", "-")}-replica-1"
  replicate_source_db     = aws_db_instance.primary.id
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.security_group_id]
  publicly_accessible     = false
  availability_zone       = "eu-central-1b"
  skip_final_snapshot     = true
  depends_on              = [aws_db_instance.primary]

  tags = {
    Name = "Read Replica 1"
  }
}

resource "aws_db_instance" "read_replica_2" {
  identifier              = "${replace(lower(var.db_name), "_", "-")}-replica-2"
  replicate_source_db     = aws_db_instance.primary.id
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [var.security_group_id]
  publicly_accessible     = false
  availability_zone       = "eu-central-1c"
  skip_final_snapshot     = true
  depends_on              = [aws_db_instance.primary]

  tags = {
    Name = "Read Replica 2"
  }
}
