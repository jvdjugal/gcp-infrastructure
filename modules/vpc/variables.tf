variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
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
