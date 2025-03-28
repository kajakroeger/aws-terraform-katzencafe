
/*
Wurde auskommentiert, da die Webseite nicht wie geplant über Route53 
sondern über CloudFront mit Standard Domain ausgeliefert wird. 
Route53 wird daher vorerst nicht gebraucht.


Verwaltet die DNS-Einstellungen der Domain
  - registriert die Domain samtpfoten-lounge.de über AWS Route 53, 
  - erstellt eine Hosted Zone für die Domain 
  - legt DNS-Alias-Record an, um www.samtpfoten-lounge.de auf CloudFront umzuleiten


# Registriert die Domain samtpfoten-lounge.de
resource "aws_route53domains_registered_domain" "domain" {
  domain_name = "samtpfoten-lounge.de"

  admin_contact {
    first_name     = "Kaja"
    last_name      = "Kröger"
    email          = "k.kroeger.hst@gmail.com"
    phone_number   = "+49.15120177319"
    address_line_1 = "Blücherstraße 23"
    city           = "Rostock"
    country_code   = "DE"
    zip_code       = "18055"
  }
  registrant_contact {
    first_name     = "Kaja"
    last_name      = "Kröger"
    email          = "k.kroeger.hst@gmail.com"
    phone_number   = "+49.15120177319"
    address_line_1 = "Blücherstraße 23"
    city           = "Rostock"
    country_code   = "DE"
    zip_code       = "18055"
  }
  tech_contact {
    first_name     = "Kaja"
    last_name      = "Kröger"
    email          = "k.kroeger.hst@gmail.com"
    phone_number   = "+49.15120177319"
    address_line_1 = "Blücherstraße 23"
    city           = "Rostock"
    country_code   = "DE"
    zip_code       = "18055"
  }
}

# Erstellt DNS-Hosted Zone zum Speichern & Verwalten der DNS-Records
# Ermöglicht Verbindung der Domain mit anderen Services wie CloudFront und S3
resource "aws_route53_zone" "primary" {
  name = "samtpfoten-lounge.de"
}

# Leitet die Domain auf CloudFront weiter
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.samtpfoten-lounge.de"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

*/











