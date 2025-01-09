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
  type = map(object({
    auto_create_subnetworks = bool
    create_nat              = bool
    subnets = list(object({
      name          = string
      ip_cidr_range = string
      region        = string
      private       = bool
      secondary_ip_ranges = optional(list(object({
        range_name    = string
        ip_cidr_range = string
      })))
    }))
    firewall_rules = list(object({
      name          = string
      protocol      = string
      ports         = list(string)
      source_ranges = list(string)
      target_tags   = optional(list(string))
    }))
  }))
  description = "Map of VPC configurations"
}
variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
}
