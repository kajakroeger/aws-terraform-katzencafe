/*
Zentrale Steuerungsdatei für Terraform, um alle Module zu organisieren
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-central-1" # Frankfurt Region für DSGVO-Konformität
}

