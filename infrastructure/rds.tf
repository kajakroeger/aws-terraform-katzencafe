/*
Erstellt eine PostgreSQL-Datenbank innerhalb einer VPC Security Group in AWS RDS
*/

# Erstellt die Subnet Group 
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "katzencafe-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id] # Private Subnetze
  tags = {
    Name = "Katzencafe DB Subnet Group"
  }
}

# Erstellt die PostgreSQL-Datenbank 
resource "aws_db_instance" "postgres" {
  db_name                 = "katzencafedb"
  identifier              = "katzencafe-db"
  engine                  = "postgres"
  engine_version          = "14.16"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20  # In GB
  max_allocated_storage   = 100 # Skalierbar bis 100 GB, falls nötig
  storage_type            = "gp2"
  storage_encrypted       = true
  backup_retention_period = 7 # Backups werden für 7 Tage gespeichert
  multi_az                = true
  username                = "masteruser"
  password                = jsondecode(data.aws_secretsmanager_secret_version.db_password_value.secret_string)["password"] # Holt das Passwort sicher aus AWS Secrets 
  parameter_group_name    = "default.postgres14"
  publicly_accessible     = true
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name # Verknüpfung mit Subnet-Group
  tags = {
    Name        = "Katzencafe-DB"
    Environment = "Production"
  }
}