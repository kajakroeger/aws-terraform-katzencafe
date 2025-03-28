/*
Speichert sensible Daten, wie Passwörter in AWS Secrets Manager
*/

# Erstellt Secret im AWS Secrets Manager als leeren Platzhalter
resource "aws_secretsmanager_secret" "db_password" {
  name = "katzencafe-db-password"
}

# Speichert das Passwort im Platzhalter
resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    password = "mein-sicheres-passwort"
  })
}