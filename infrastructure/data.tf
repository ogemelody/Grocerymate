data "aws_instance" "instance" {
  filter {
    name = "tag:Name"
    values = [grocery-mate-server]
  }
}
