# Enable required Google APIs
module "enable_apis" {
  source     = "../../modules/apis"
  project_id = var.project_id
  apis       = var.apis
}

# VPC Module
module "vpc" {
  source     = "../../modules/vpc"
  project_id = var.project_id
  region     = var.region
  vpc_name   = var.vpc_name
  vpcs       = var.vpcs

}

resource "google_service_account" "jugal_tf_sa" {
  account_id   = "jugal-tf-sa"
  display_name = "Jugal Terraform Service Account"
  project      = "dspl-24-poc" # Use your actual project ID here
}
