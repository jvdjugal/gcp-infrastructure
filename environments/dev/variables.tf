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

# VPC Peering Configuration


# Google APIs
variable "apis" {
  description = "List of Google Cloud APIs to enable for the project."
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com"
  ]
}

# Network configuration
variable "network_name" {
  description = "Name of the network for VPC."
  type        = string
  default     = "my-vpc"
}

# Subnet Configuration

# Firewall rules configuration


# Other required configurations


# VPC Peering Range
