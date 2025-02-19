# General Variables
variable "environment" {
  description = "Environment for the resources (e.g., dev, staging, prod)"
  type        = string
}
# Project ID and Region
variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}
variable "region" {
  description = "The region where the resources will be created."
  type        = string
}

# VPC Configuration
variable "vpcs" {
  description = "Map of VPC configurations where each VPC has subnetworks and firewall rules."
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

variable "vpc_name" {
  description = "The name of the VPC to be used."
  type        = string
}

# Google APIs
variable "apis" {
  description = "List of Google Cloud APIs to enable for the project."
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}

variable "zone" {
  description = "The zone in which the GKE cluster will be created."
  type        = string
}


variable "pods_range_name" {
  description = "The secondary range name for pods."
  type        = string
}

variable "services_range_name" {
  description = "The secondary range name for services."
  type        = string
}

variable "node_machine_type" {
  description = "The machine type for the GKE nodes."
  type        = string
  default     = "e2-micro"
}

variable "node_disk_size_gb" {
  description = "The disk size (in GB) for the GKE nodes."
  type        = number
  default     = 20
}

variable "node_disk_type" {
  description = "The disk type for the GKE nodes."
  type        = string
  default     = "pd-standard"
}

variable "primary_node_count" {
  description = "The initial number of nodes in the node pool."
  type        = number
  default     = 1
}

variable "autoscaling_min_node_count" {
  description = "The minimum number of nodes for autoscaling."
  type        = number
  default     = 1
}

variable "autoscaling_max_node_count" {
  description = "The maximum number of nodes for autoscaling."
  type        = number
  default     = 2
}

variable "gke_sa_permissions" {
  description = "List of IAM roles to assign to the GKE service account."
  type        = list(string)

}



# Cloud SQL Variables
variable "cloud_sql_config" {
  description = "Configuration for Cloud SQL instance"
  type = object({
    database_name = string
    database_user = string
    instance_settings = object({
      tier              = string
      availability_type = string
      disk_size         = number
      disk_type         = string
    })
    backup_configuration = object({
      enabled    = bool
      start_time = string
    })
    maintenance_window = object({
      day          = number
      hour         = number
      update_track = string
    })
  })
}
/*
variable "database_password" {
  description = "Password for the database user"
  type        = string
  sensitive   = true
}
*/
variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation for the GKE master network"
  type        = string
  default     = "192.168.1.0/28" # This gives us 16 IP addresses for the master nodes
}














