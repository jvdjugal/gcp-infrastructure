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
      },

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

apis = [
  "compute.googleapis.com",
  "sqladmin.googleapis.com",
  "container.googleapis.com",
  "servicenetworking.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "iam.googleapis.com"
]


# Other existing configurations...
