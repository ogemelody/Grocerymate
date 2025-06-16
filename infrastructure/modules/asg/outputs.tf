output "asg_id" {
  value       = aws_autoscaling_group.grocerymate_asg.id
  description = "ID of the Auto Scaling Group"
}
