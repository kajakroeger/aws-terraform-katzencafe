/*
Erstellt die AWS Lambda-Funktion
Verbindet Lambda mit IAM-Rolle für Zugriff auf RDS
Speichert den Code als ZIP-Datei in S3
*/

resource "aws_lambda_function" "backend" {
  function_name    = "katzencafe-backend"
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  filename         = "../backend.zip"
  role             = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("../backend.zip") # Erkennt Änderungen an backend.zip

  environment {
    variables = {
      DB_HOST    = aws_db_instance.postgres.address
      DB_USER    = "masteruser"
      DB_NAME    = "katzencafedb"
      SECRET_ARN = data.aws_secretsmanager_secret_version.db_password_value.secret_string

    }
  }

  # Lambda läuft in gleicher VPC wie die Datenbank
  vpc_config {
    subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

