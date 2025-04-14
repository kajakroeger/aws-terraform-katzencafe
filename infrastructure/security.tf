# Erstellt einen VPC Endpoint für Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-central-1.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "secretsmanager-endpoint"
  }
}

# Security Group für den VPC Endpoint des Secrets Managers
# Zugriff ist nur innerhalb der VPC erlaubt
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg"
  description = "Erlaubt HTTPS Traffic fuer den VPC Endpoint"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
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

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.lambda_sg.id]
  }

  # OPTIONAL: Erlaubt eingehenden Traffic von bestimmter IP-Adresse. Für lokale Arbeiten an der Datenbank. 
  # Bei Bedarf Code-Abschnitt aktivieren, IP-Adresse einfügen, Datenbank bearbeiten und wieder auskommentieren.
  # ingress {
  #   from_port   = 5432
  #   to_port     = 5432
  #   protocol    = "tcp"
  #   cidr_blocks = ["IP-ADRESSE/32"]
  #   description = "TEMP Zugriff von meinem Rechner"
  # }

  tags = {
    Name = "DB Security Group"
  }
}

# Erstellt Sicherheitsgruppe für AWS Lambda
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-security-group"
  description = "Erlaubt Lambda Verbindungen zur RDS-Datenbank"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]

  }

  tags = {
    Name = "Lambda Security Group"
  }
}

