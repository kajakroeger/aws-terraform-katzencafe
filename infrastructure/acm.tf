/*
Wurde entfernt, da die Webseite nicht wie geplant über Domain von Route53 
sondern über CloudFront mit Standard Domain ausgeliefert wird. 
CloudFront hat Standard Zertifikat, ACM wird daher vorerst nicht gebraucht.

Verwaltet das SSL-Zertifikat (AWS ACM) für CloudFront

# Zertifikat für www.samtpfoten-lounge.de (muss in us-east-1 sein, damit CloudFront es nutzen kann)
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.us-east-1
  domain_name       = "www.samtpfoten-lounge.de"
  validation_method = "DNS"

  # Macht Webseite auch ohne "www" verfügbar
  subject_alternative_names = ["samtpfoten-lounge.de"]

  lifecycle {
    create_before_destroy = true
  }
}

# Automatische DNS-Validierung für Route 53
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.primary.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

# Automatische validierung des ACM-Zertifikats
resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Output für die Nutzung in CloudFront
output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}


*/
