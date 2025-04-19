# Die Datenquellen lesen das Datenbank-Passwort aus dem AWS Secrets Manager aus 
# Terraform kann damit auf das im AWS Secrets Manager gespeicherte Passwort zugreifen,
# ohne dass es im Klartext im Code steht.
data "aws_secretsmanager_secret" "db_password" {
  name = "secret-rds"
}

data "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}
