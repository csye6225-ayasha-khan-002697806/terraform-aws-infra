resource "random_string" "secret_suffix" {
  length  = 8
  upper   = false
  special = false
}
resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "database-password-${random_string.secret_suffix.result}"
  kms_key_id              = aws_kms_key.secrets_kms_key.arn
  description             = "Database password for RDS instance"
  recovery_window_in_days = 30
  tags = {
    Name = "Database Password Secret-${timestamp()}"
  }
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  depends_on = [
    random_password.db_password,
    aws_db_instance.csye6225_postgres_instance
  ]
  secret_string = <<EOF
{
  "password": "${random_password.db_password.result}"
}
EOF
}

resource "aws_secretsmanager_secret" "email_service_credentials" {
  name        = "email_service_credentials_${random_string.secret_suffix.result}"
  description = "Email service credentials for sending emails"
  kms_key_id  = aws_kms_key.secrets_kms_key.arn # Use the same KMS key

  tags = {
    Name = "email_service_credentials_secret_${timestamp()}"
  }
}

resource "aws_secretsmanager_secret_version" "email_service_credentials_version" {
  secret_id = aws_secretsmanager_secret.email_service_credentials.id
  secret_string = jsonencode({
    sendgrid_api_key = var.sendgrid_api_key

  })
}
