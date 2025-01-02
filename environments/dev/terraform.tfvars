# General Configuration
project_id  = "dspl-24-poc"
region      = "us-central1"
environment = "dev"

# VPC Configuration
vpcs = {
  "my-vpc" = {
    auto_create_subnetworks = false
    create_nat              = true
    subnets = [
      {
        name          = "gke-subnet"
        ip_cidr_range = "10.0.0.0/16"
        region        = "us-central1"
        private       = true
        secondary_ip_ranges = [
          {
            range_name    = "gke-pods"
            ip_cidr_range = "10.2.0.0/20"
          },
          {
            range_name    = "gke-services"
            ip_cidr_range = "10.3.0.0/20"
          }
        ]
      }
    ]
    firewall_rules = [
      {
        name          = "allow-internal"
        protocol      = "tcp"
        ports         = ["22", "80", "443"]
        source_ranges = ["10.0.0.0/16", "10.1.0.0/16"]
      }
    ]
  }
}

# VPC name configuration
vpc_name = "my-vpc"

#Custom Service account



# GKE Configuration
cluster_name               = "dev-cluster"
master_ipv4_cidr_block     = "172.16.0.0/28"
authorized_network_cidr    = "10.0.0.0/16"
pods_range_name            = "gke-pods"
services_range_name        = "gke-services"
primary_node_count         = 1
autoscaling_min_node_count = 1
autoscaling_max_node_count = 2
node_machine_type          = "e2-micro"
node_disk_size_gb          = 30
node_disk_type             = "pd-ssd"

google_service_account_email = "gke-node-pool-sa@dspl-24-poc.iam.gserviceaccount.com"
network_id                   = "projects/dspl-24-poc/global/networks/my-vpc"
subnet_id                    = "projects/dspl-24-poc/regions/us-central1/subnetworks/gke-subnet"
zone                         = "us-central1-a"



# Permission List in .tfvars file



# Required APIs
apis = [
  "cloudresourcemanager.googleapis.com",
  "iam.googleapis.com",
  "compute.googleapis.com",
  "sqladmin.googleapis.com",
  "container.googleapis.com",
  "servicenetworking.googleapis.com",
  "dns.googleapis.com"
]
