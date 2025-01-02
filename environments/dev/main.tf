# Enable required Google APIs
module "enable_apis" {
  source     = "../../modules/apis"
  project_id = var.project_id
  apis       = var.apis
}
# VPC Module
module "vpc" {
  source      = "../../modules/vpc"
  project_id  = var.project_id
  region      = var.region
  vpc_name    = var.vpc_name
  vpcs        = var.vpcs
  environment = var.environment

  depends_on = [module.enable_apis] # Add this line to ensure APIs are enabled first
}

module "GKE" {
  source = "../../modules/GKE"



  project_id                   = var.project_id
  cluster_name                 = var.cluster_name
  zone                         = var.zone
  network_id                   = module.vpc.network_id # Adjusted to match the output name
  subnet_id                    = module.vpc.subnet_ids["gke-subnet"]
  master_ipv4_cidr_block       = var.master_ipv4_cidr_block
  authorized_network_cidr      = var.authorized_network_cidr
  pods_range_name              = var.pods_range_name
  services_range_name          = var.services_range_name
  google_service_account_email = var.google_service_account_email


  depends_on = [module.vpc]
}
