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
variable "apis" {
  description = "List of Google APIs to enable"
  type        = list(string)
}

variable "vpc_name" {
  description = "The name of the VPC network to be created"
  type        = string
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
  validation {
    condition     = length(keys(var.vpcs)) > 0
    error_message = "At least one VPC configuration is required."
  }
}


