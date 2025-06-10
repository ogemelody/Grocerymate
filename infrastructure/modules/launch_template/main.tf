resource "aws_launch_template" "grocerymate-app-launch-template" {
  name_prefix   = "grocerymate-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [var.security_group_id]
  user_data              = base64encode(file("${path.module}/user_data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.name
    }
  }
}
