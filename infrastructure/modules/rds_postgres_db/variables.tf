variable "db_username" {
  type = string
}

variable "db_name" {
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS subnet group (across 3 AZs)"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID for the RDS instance"
  type        = string
}


variable "secret_arn" {
  description = "ARN of the secret storing DB password"
  type        = string
}
