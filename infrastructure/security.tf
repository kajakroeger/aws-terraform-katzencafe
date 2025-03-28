# Security Group für VPC Endpoint (Secrets Manager)
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg"
  description = "Erlaubt HTTPS Traffic fuer den VPC Endpoint"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Zugriff nur innerhalb deiner VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC Endpoint SG"
  }
}




# Erstellt Sicherheitsgruppe für RDS
resource "aws_security_group" "db_sg" {
  name        = "rds-security-group"
  description = "Erlaubt Zugriff auf die Datenbank von Lambda"
  vpc_id      = aws_vpc.main.id

  # Erlaubt nur Verbindungen von Lambda (PostgreSQL Port 5432)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.lambda_sg.id] # Erlaubt nur Lambda-Zugriff
  }

  # TEMPORÄR: Erlaubt Zugriff von deiner IP-Adresse (nur für Setup!)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["82.82.106.238/32"]
    description = "TEMP Zugriff von meinem Rechner"
  }

  # Erlaubt ausgehenden Traffic (z.B. zu S3 oder externen APIs)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB Security Group"
  }
}

# Erstellt Sicherheitsgruppe für AWS Lambda
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-security-group"
  description = "Erlaubt Lambda Verbindungen zur RDS-Datenbank"
  vpc_id      = aws_vpc.main.id

  # Erlaubt ausgehenden Traffic, damit Lambda Anfragen senden kann
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Lambda Security Group"
  }
}

