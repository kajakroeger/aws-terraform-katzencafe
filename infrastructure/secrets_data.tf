# Die Datenquellen lesen das Passwort Datenbank-Passwort aus dem AWS Secrets Manager aus 

data "aws_secretsmanager_secret" "db_password" {
  name = "katzencafe-db-password"
}

data "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}
