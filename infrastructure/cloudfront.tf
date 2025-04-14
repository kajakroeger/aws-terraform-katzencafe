/*
Erstellt eine CloudFront-Distribution, um S3-Inhalte weltweit bereitzustellen
  - CloudFront unterstützt schnelle, sichere und globale Bereitstellung der Webseite. 
  - Während die Webseite im S3-Bucket gespeichert ist, verwaltet und optimiert CloudFront den Zugriff auf die Webseiteninhalte.
  - Es erstellt CloudFront Distribution, womit die Webseite weltweit über CDN aufgerufen werden kann.
  - Passt sich dank automatischer Skalierung dynamisch dem Datenverkehr an.
  - S3 ist nicht öffentlich. Nur CloudFront hat über OAC Zugriff auf S3-Bucket. 
  - CloudFornt nutzt HTTPS-Verschlüsselung durch ACM-Zertifikat für sichere Datenübertragung.
  - Speichert Webseiteninhalte an weltweiten Edge-Standorten (cashing), um Ladezeiten zu minimieren.
*/

# OAC-Zugriff für CloudFront auf den nicht-öffentlichen S3-Bucket 
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "S3-OAC"
  description                       = "OAC für S3 Zugriff"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Response Header Policy für CORS, um Cross-Origin Requests zu erlauben
resource "aws_cloudfront_response_headers_policy" "cors_policy" {
  name = "CORS-Policy"

  cors_config {
    access_control_allow_origins {
      items = ["*"]  # Erlaubt alle Ursprünge, bei Bedarf anpassen
    }
    access_control_allow_headers {
      items = ["*"]
    }
    access_control_allow_methods {
      items = ["GET", "HEAD"]
    }
    access_control_allow_credentials = false # auf true setzen, wenn Login/Authentifizierung erwünscht. Mit true können Credentials (Cookies, Auth-Header) übertragen werden
    origin_override = true
  }

  security_headers_config {
    # Schützt vor Clickjacking, verhindert dass die Webseite in iFrames geladen wird
    frame_options {
      override = true
      frame_option = "DENY"
    }
    # Verhindert MIME-Typ-Sniffing
    content_type_options {
      override = true
    }
    # Nur Referrer aus der eigenen Domain werden übermittelt (unterstützt Datenschutz)
    referrer_policy {
      override = true
      referrer_policy = "same-origin"
    }
    # Erzwingt HTTPS für eine lange Zeit, inkl. Subdomains
    strict_transport_security {
      override = true
      access_control_max_age_sec = 63072000
      include_subdomains = true
      preload = true
    }
    # Aktiviert den Cross Site Scriting Schutz des Browsers
    xss_protection {
    override = true
    protection = true
    mode_block = true
    report_uri = "" # optional: Zum Melden von Angriffen
  }
  }
}

# CloudFront Distribution für globale Bereitstellung & HTTPS
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "S3WebsiteOrigin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "S3WebsiteOrigin"
    # Bewirkt eine automatische Umleitung auf HTTPS
    viewer_protocol_policy = "redirect-to-https"
    # Erlaubt nur Lesezugriffe
    allowed_methods = ["GET", "HEAD"]
    # Definiert, welche Mthoden CloudFront zwischenspeichern darf
    cached_methods = ["GET", "HEAD"]
    
    # Von AWS empfohlene Cache-Policy (AWS Managed CachingOptimized)
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    min_ttl     = 0        # Kein Caching bei Aktualisierung  
    default_ttl = 86400    # 86400sec (24h) als Standard-Cache-Dauer
    max_ttl     = 31536000 # 1 Jahr als Maximale Cache-Dauer 

    response_headers_policy_id = aws_cloudfront_response_headers_policy.cors_policy.id
  }

  # Erlaubt weitweite Verfügbarkeit. Falls bestimmte Länder keinen Zugriff haben sollen, 
  # kann anstelle von "none" das entsprechende Land blockiert werden (z.B. "DE" für Deutschland)
  restrictions {
    geo_restriction {
      restriction_type = "none" # keine Ländereinschränkungen, für globale Verfügbarkeit
    }
  }

  # Standard TLS Zertifikat von CloudFront
  viewer_certificate {
    cloudfront_default_certificate = true
  }

}