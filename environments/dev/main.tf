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

  project_id         = var.project_id
  cluster_name       = var.cluster_name
  zone               = var.zone
  network_id         = module.vpc.network_id["my-vpc"]
  gke_sa_permissions = var.gke_sa_permissions # Pass the permissions here



  subnet_id           = module.vpc.subnet_ids["my-vpc-gke-subnet"]
  pods_range_name     = var.pods_range_name
  services_range_name = var.services_range_name

  depends_on = [module.vpc]
}

module "cloud_sql" {
  source = "../../modules/cloud-sql"

  project_id  = var.project_id
  environment = var.environment
  region      = var.region
  network_id  = module.vpc.network_id["my-vpc"]

  database_name     = "mydb"
  database_user     = "dbuser"
  database_password = var.database_password # Add this to your variables

  depends_on = [module.vpc]
}
