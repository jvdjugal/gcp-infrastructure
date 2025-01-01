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
