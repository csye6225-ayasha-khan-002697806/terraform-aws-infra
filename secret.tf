resource "random_string" "secret_suffix" {
  length  = 8
  upper   = false
  special = false
}
resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "database-password-${random_string.secret_suffix.result}"
  kms_key_id              = aws_kms_key.secrets_kms_key.id
  description             = "Database password for RDS instance"
  recovery_window_in_days = 30
  tags = {
    Name = "Database Password Secret - ${timestamp()}"
  }
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
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

