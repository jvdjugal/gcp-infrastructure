provider "google" {
  credentials = file("key.json")
  project     = var.project_id
  region      = var.region
}



//verify this with the official documentation
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

//terraform import google_service_account.jugal_tf_sa projects/dspl-24-poc/serviceAccounts/jugal-tf-sa@dspl-24-poc.iam.gserviceaccount.com
