# General Configuration
project_id        = "dspl-24-poc"
region            = "us-central1"
environment       = "dev"
network_name      = "my-vpc"
sql_instance_name = "my-instance"
sql_tier          = "db-f1-micro"

frontend_image    = "your-frontend-image"
backend_image     = "your-backend-image"
frontend_replicas = 2
backend_replicas  = 2
frontend_port     = 80
backend_port      = 5000

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
      {
        name                = "sql-subnet"
        ip_cidr_range       = "10.1.0.0/16"
        region              = "us-central1"
        private             = true
        secondary_ip_ranges = []
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

# Network ID (typically should correspond to your network's ID)
network_id = "my-vpc" # Set this to the actual network ID in your GCP project

# Other existing configurations...
cluster_name           = "dev-cluster"
master_ipv4_cidr_block = "172.16.0.0/28"
pod_range_name         = "gke-pods"
service_range_name     = "gke-services"
instance_name          = "dev-sql-instance" # Add the instance_name value here
database_version       = "POSTGRES_14"
tier                   = "db-f1-micro"
node_pools = [
  {
    name         = "default-pool"
    machine_type = "e2-medium"
    disk_size_gb = 100
    node_count   = 1
    min_count    = 1
    max_count    = 3
    node_version = "1.27.3-gke.100" # Use your desired GKE version
    image_type   = "COS_CONTAINERD"
    labels = {
      environment = "dev"
    }
  }
]


# Cloud SQL Configuration
sql_instances = {
  "my-instance" = {
    name              = "my-instance"
    database_version  = "POSTGRES_14"
    tier              = "db-f1-micro"
    region            = "us-central1"
    backup_start_time = "02:00"
    maintenance_window = {
      day          = 7
      hour         = 3
      update_track = "stable"
    }
  }
}

sql_databases = [
  {
    name      = "my_database"
    charset   = "utf8"
    collation = "utf8_general_ci"
    instance  = "my-instance" # Make sure this corresponds to the 'sql_instance_name'
  }
]

sql_users = [
  {
    name     = "admin"
    password = "secure_password"
    host     = "%"
    instance = "my-instance" # Make sure this corresponds to the 'sql_instance_name'
  }
]
