provider "google" {
  credentials = file("/home/jugal/Downloads/dspl-24-poc-b992e28073cc.json")
  project     = var.project_id
  region      = var.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.10.0"
    }
  }
}
