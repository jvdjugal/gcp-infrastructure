provider "google" {
  credentials = file("key.json")
  project     = var.project_id
  region      = var.region
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20.0" # Adjust version as needed
    }
  }
}
