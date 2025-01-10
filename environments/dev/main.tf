# Enable APIs Module
module "enable_apis" {
  source     = "../../modules/apis"
  project_id = var.project_id
  apis       = var.apis
}

# Artifact Registry Module
module "artifact_registry" {
  source     = "../../modules/artifact-registry" # Path to your module
  project_id = var.project_id

  repository_id = var.repository_id
  location      = var.location
  description   = var.description
  format        = var.format
}

# VPC Module
module "vpc" {
  source      = "../../modules/vpc"
  project_id  = var.project_id
  region      = var.region
  vpc_name    = var.vpc_name
  vpcs        = var.vpcs
  environment = var.environment

  depends_on = [module.enable_apis] # Ensure APIs are enabled first
}

# GKE Module
module "GKE" {
  source = "../../modules/GKE"

  # Existing variables
  project_id              = var.project_id
  cluster_name            = var.cluster_name
  zone                    = var.zone
  network_id              = module.vpc.network_id["my-vpc"]
  gke_sa_permissions      = var.gke_sa_permissions
  authorized_network_cidr = var.authorized_network_cidr
  subnet_id               = module.vpc.subnet_ids["my-vpc-gke-subnet"]
  pods_range_name         = var.pods_range_name
  services_range_name     = var.services_range_name
  master_ipv4_cidr_block  = var.master_ipv4_cidr_block

  # New variables for private cluster and bastion
  master_global_access_config_enabled = var.master_global_access_config_enabled
  bastion_cidr                        = var.bastion_cidr
  bastion_instance_name               = var.bastion_instance_name
  bastion_machine_type                = var.bastion_machine_type
  bastion_image                       = var.bastion_image
  bastion_tags                        = var.bastion_tags
  iap_firewall_name                   = var.iap_firewall_name
  iap_source_ranges                   = var.iap_source_ranges

  depends_on = [module.vpc, module.artifact_registry]
}

# Cloud SQL Module
module "cloud_sql" {
  source = "../../modules/cloud-sql"

  project_id     = var.project_id
  environment    = var.environment
  region         = var.region
  network_id     = module.vpc.network_id["my-vpc"]
  vpc_connection = module.vpc.private_vpc_connection

  database_name = var.cloud_sql_config.database_name
  database_user = var.cloud_sql_config.database_user

  instance_settings    = var.cloud_sql_config.instance_settings
  backup_configuration = var.cloud_sql_config.backup_configuration
  maintenance_window   = var.cloud_sql_config.maintenance_window

  depends_on = [
    module.vpc,
    module.enable_apis,
    module.artifact_registry # Add this line to ensure Artifact Registry is created before Cloud SQL
  ]
}
