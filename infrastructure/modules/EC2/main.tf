resource "aws_instance" "app_server" {
  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  key_name                   = var.key_name

  tags = {
    Name = var.instance_name
  }
}
