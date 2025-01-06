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



  subnet_id              = module.vpc.subnet_ids["my-vpc-gke-subnet"]
  pods_range_name        = var.pods_range_name
  services_range_name    = var.services_range_name
  master_ipv4_cidr_block = var.master_ipv4_cidr_block # Add this line


  depends_on = [module.vpc]
}

module "cloud_sql" {
  source = "../../modules/cloud-sql"

  project_id     = var.project_id
  environment    = var.environment
  region         = var.region
  network_id     = module.vpc.network_id["my-vpc"]
  vpc_connection = module.vpc.private_vpc_connection

  database_name     = var.cloud_sql_config.database_name
  database_user     = var.cloud_sql_config.database_user
  database_password = var.database_password

  instance_settings           = var.cloud_sql_config.instance_settings
  backup_configuration        = var.cloud_sql_config.backup_configuration
  maintenance_window          = var.cloud_sql_config.maintenance_window
  database_password_secret_id = module.cloud_sql.db_password_secret_id

  depends_on = [module.vpc]
}


