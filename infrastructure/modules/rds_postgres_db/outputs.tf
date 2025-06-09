output "rds_endpoint" {
  description = "RDS connection endpoint"
  value       = aws_db_instance.primary.endpoint
}

output "secret_arn" {
  description = "ARN of Secrets Manager secret for DB credentials"
  value       = data.aws_secretsmanager_secret.db_password.arn
}
