# environments/dev/main.tf

# Enable required Google APIs
module "enable_apis" {
  source     = "../../modules/apis"
  project_id = var.project_id
  apis = [
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com" # Added for service account management
  ]
}
# VPC Network and Subnets
module "vpc" {
  source        = "../../modules/vpc"
  project_id    = var.project_id
  region        = var.region
  vpc_name      = var.vpc_name
  vpcs          = var.vpcs
  instance_name = "my-instance"
  network_id    = "my-vpc"
}
module "service-accounts" {
  source     = "../../modules/service-accounts"
  project_id = var.project_id
}
module "gke" {
  source                 = "../../modules/gke"
  vpc_module             = module.vpc # Pass vpc module as an input
  project_id             = var.project_id
  region                 = var.region
  cluster_name           = var.cluster_name
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  pod_range_name         = var.pod_range_name
  service_range_name     = var.service_range_name
  node_pools             = var.node_pools
  network_id             = module.vpc.network_id
  environment            = var.environment
  subnet_name            = "gke-subnet"
  network_name           = "my-vpc"
  gke_service_account    = module.service-accounts.gke_sa_email
  depends_on             = [module.service-accounts]
}

module "k8s-deployment" {
  source = "../../modules/k8s-deployment"

  frontend_image    = var.frontend_image
  backend_image     = var.backend_image
  frontend_replicas = var.frontend_replicas
  backend_replicas  = var.backend_replicas
  frontend_port     = var.frontend_port
  backend_port      = var.backend_port
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = "default"
  }
  spec {
    selector = {
      app = "frontend"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend-service"
    namespace = "default"
  }
  spec {
    selector = {
      app = "backend"
    }
    port {
      port        = 5000
      target_port = 5000
    }
  }
}


output "frontend_service" {
  value = kubernetes_service.frontend.metadata[0].name
}

output "backend_service" {
  value = kubernetes_service.backend.metadata[0].name
}


module "cloud_sql" {
  source           = "../../modules/cloud-sql"
  tier             = var.sql_tier
  environment      = var.environment
  instance_name    = var.sql_instance_name
  region           = var.region
  database_version = var.database_version
  network_id       = module.vpc.network_id
  project_id       = var.project_id
  sql_instances    = var.sql_instances
  sql_databases    = var.sql_databases
  sql_users        = var.sql_users
  # Add this line to satisfy the variable requirement
  reserved_peering_ranges = var.reserved_peering_ranges
  depends_on              = [module.vpc]
}
output "cluster_name" {
  description = "GKE cluster name"
  value       = module.gke.cluster_name
}
output "cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}
output "sql_instance_names" {
  description = "Cloud SQL instance names"
  value       = module.cloud_sql.instance_names
}
output "network_name" {
  description = "VPC network name"
  value       = values(module.vpc.network_names)[0] # Changed from network_name to network_names
}
