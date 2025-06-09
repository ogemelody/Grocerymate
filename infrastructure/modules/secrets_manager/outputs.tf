
output "secret_arn" {
  value       = aws_secretsmanager_secret.db_password.arn
  description = "ARN of the DB password secret"
}
