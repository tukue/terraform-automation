terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.33.0"
    }
  }
  required_version = ">= 1.0"
}