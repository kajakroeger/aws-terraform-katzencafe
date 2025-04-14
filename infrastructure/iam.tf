/*
Vergibt IAM-Rollen & Berechtigungen für Lambda & S3
*/

# IAM Rolle für Lambda 
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY
}

# Lambda-Berechtigung für Zugriff auf AWS Secrets Manager
resource "aws_iam_policy" "lambda_secrets_access" {
  name        = "lambda-secrets-access"
  description = "Erlaubt Lambda, das Passwort aus Secrets Manager zu holen"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = data.aws_secretsmanager_secret_version.db_password_value.secret_string

    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_rds_access" {
  name       = "lambda-rds-access"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

# VPC Access Permission
# Gibt Lambda die Erlaubnis sich mit der VPC zu verbinden, 
# damit sie auf die Datenbank im privaten Subnet zugreifen kann.
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# S3-Bucket-Policy: Nur CloudFront OAC darf lesen
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "AllowCloudFrontServicePrincipalReadOnly",
      Effect    = "Allow",
      Principal = {
        Service = "cloudfront.amazonaws.com"
      },
      Action    = "s3:GetObject",
      Resource  = "arn:aws:s3:::${aws_s3_bucket.website.bucket}/*",
      Condition = {
        StringEquals = {
          "AWS:SourceArn": aws_cloudfront_distribution.cdn.arn
        }
      }
    }]
  })
}
