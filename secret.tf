resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "database-password"
  kms_key_id              = aws_kms_key.secrets_kms_key.id
  description             = "Database password for RDS instance"
  recovery_window_in_days = 30
  tags = {
    Name = "Database Password Secret"
  }
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = <<EOF
{
  "password": "${random_password.db_password.result}",
  "username": "${var.db_username}",
  "host": "${aws_db_instance.csye6225_postgres_instance.address}",
  "port": "${var.db_port}",
  "dbname": "${var.db_name}"
}
EOF
}

