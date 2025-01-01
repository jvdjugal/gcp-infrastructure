# General Variables
variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment for the resources (e.g., dev, staging, prod)"
  type        = string
}


# VPC and Subnet Variables
variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}
variable "network_id" {
  description = "The ID or name of the VPC network"
  type        = string
}




variable "sql_instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
}

variable "sql_databases" {
  description = "List of databases for Cloud SQL instances"
  type = list(object({
    name      = string
    instance  = string
    charset   = optional(string, "utf8mb4")
    collation = optional(string, "utf8mb4_general_ci")
  }))
}

variable "sql_users" {
  description = "List of users for Cloud SQL instances"
  type = list(object({
    name     = string
    instance = string
  }))
}






variable "sql_instances" {
  description = "Map of Cloud SQL instances to be created"
  type = map(object({
    name              = string
    database_version  = string
    tier              = string
    region            = string
    backup_start_time = string
    maintenance_window = object({
      day          = number
      hour         = number
      update_track = string
    })
  }))
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "gke-subnet" # Providing a default value
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
}

# variables.tf in the environments/dev folder
# modules/cloud-sql/variables.tf
variable "reserved_peering_ranges" {
  description = "The reserved IP range for VPC peering"
  type        = list(string)
  default     = [] # Making it optional by providing a default value
}








variable "subnet_configs" {
  description = "List of subnet configurations"
  type = list(object({
    name          = string
    ip_cidr_range = string
    region        = string
    private       = bool
    secondary_ip_ranges = list(object({
      range_name    = string
      ip_cidr_range = string
    }))
  }))
}

# GKE Cluster Variables
variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "The CIDR block for the GKE master endpoint"
  type        = string
}

variable "pod_range_name" {
  description = "The name of the secondary IP range for Pods"
  type        = string
}

variable "service_range_name" {
  description = "The name of the secondary IP range for Services"
  type        = string
}



# Cloud SQL Variables
variable "instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "The version of the database"
  type        = string
}

variable "sql_tier" {
  description = "Tier for the Cloud SQL instance (e.g., db-f1-micro)"
  type        = string
}



variable "tier" {
  description = "The tier for the Cloud SQL instance"
  type        = string
}

# Add this to your existing variables.tf
variable "vpcs" {
  description = "Map of VPC configurations"
  type = map(object({
    auto_create_subnetworks = bool
    create_nat              = bool
    subnets = list(object({
      name          = string
      ip_cidr_range = string
      region        = string
      private       = bool
      secondary_ip_ranges = list(object({
        range_name    = string
        ip_cidr_range = string
      }))
    }))
    firewall_rules = list(object({
      name          = string
      protocol      = string
      ports         = list(string)
      source_ranges = list(string)
    }))
  }))
}

variable "node_pools" {
  description = "List of node pool configurations"
  type = list(object({
    name         = string
    machine_type = string
    disk_size_gb = number
    node_count   = number
    min_count    = number
    max_count    = number
    node_version = string
    image_type   = string
    labels       = map(string)
  }))
  default = [
    {
      name         = "default-pool"
      machine_type = "e2-medium"
      disk_size_gb = 100
      node_count   = 1
      min_count    = 1
      max_count    = 3
      node_version = "1.27.3-gke.100"
      image_type   = "COS_CONTAINERD"
      labels = {
        environment = "dev"
      }
    }
  ]
}

variable "frontend_image" {
  description = "Docker image for the frontend application"
  type        = string
}

variable "backend_image" {
  description = "Docker image for the backend application"
  type        = string
}

variable "frontend_replicas" {
  description = "Number of replicas for the frontend deployment"
  type        = number
  default     = 1
}

variable "backend_replicas" {
  description = "Number of replicas for the backend deployment"
  type        = number
  default     = 1
}

variable "frontend_port" {
  description = "Port number for the frontend service"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Port number for the backend service"
  type        = number
  default     = 5000
}

