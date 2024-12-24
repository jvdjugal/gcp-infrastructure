module "vpc" {
  source       = "../../modules/vpc"
  network_name = "my-vpc"
  region       = "us-central1"
  subnet_configs = [
    {
      name          = "gke-subnet"
      ip_cidr_range = "10.0.0.0/16"
      region        = "us-central1"
      private       = true
      secondary_ip_ranges = [
        {
          range_name    = "gke-pod-range"
          ip_cidr_range = "10.0.1.0/24"
        }
      ]
    },
    {
      name                = "sql-subnet"
      ip_cidr_range       = "10.1.0.0/16"
      region              = "us-central1"
      private             = true
      secondary_ip_ranges = []
    }
  ]
}


module "enable_apis" {
  source     = "../../modules/apis"
  project_id = var.project_id
  apis = [
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

module "gke" {
  source = "../../modules/gke"

  project_id             = var.project_id
  region                 = var.region
  environment            = "dev"
  cluster_name           = "dev-cluster"
  network_id             = module.vpc.network_id
  subnet_id              = module.vpc.subnet_ids["gke-subnet"]
  master_ipv4_cidr_block = "172.16.0.0/28"

  node_pools = [
    {
      name         = "general-pool"
      machine_type = "e2-standard-2"
      min_count    = 1
      max_count    = 3
      disk_size_gb = 100
    }
  ]
}


module "cloud_sql" {
  source = "../../modules/cloud-sql"

  project_id       = var.project_id
  region           = var.region
  environment      = "dev"
  instance_name    = "dev-sql"
  network_id       = module.vpc.network_id
  database_version = "POSTGRES_14"
  tier             = "db-f1-micro"
}


