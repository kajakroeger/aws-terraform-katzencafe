/*
Erstellt & konfiguriert den S3-Bucket für statische Dateien
  - S3-Bucket ist privat / nicht öffentlich zugänglich, was die Datensicherheit erhöht.
  - Mit Origin Access Control (OAC) greift CloudFront sicher auf die Inhalt von S3 zu.
*/

# Ermöglicht Verweise auf Account-Informationen wie AWS Account-ID, IAM User und Rollen ID
data "aws_caller_identity" "current" {}

# Erstellt S3 Bucket 
resource "aws_s3_bucket" "website" {
  bucket = "samtpfoten-lounge"
}

# Entfernt öffentlichen Zugriff auf den S3-Bucket
resource "aws_s3_bucket_public_access_block" "website_public_access" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Verschlüsselte Speicherung der Daten im S3-Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


