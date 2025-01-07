variable "project_id" {
  description = "The project ID to create the Cloud SQL instance in"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "region" {
  description = "The region to create the Cloud SQL instance in"
  type        = string
}

variable "network_id" {
  description = "The VPC network ID to connect the Cloud SQL instance to"
  type        = string
}

variable "vpc_connection" {
  description = "The private VPC connection from the VPC module"
  type        = any
}

variable "database_name" {
  description = "The name of the default database to create"
  type        = string
}

variable "database_user" {
  description = "The name of the default user to create"
  type        = string
}


variable "instance_settings" {
  description = "Settings for the database instance"
  type = object({
    tier              = string
    availability_type = string
    disk_size         = number
    disk_type         = string
  })
}

variable "backup_configuration" {
  description = "Backup configuration for the database"
  type = object({
    enabled    = bool
    start_time = string
  })
}

variable "maintenance_window" {
  description = "Maintenance window configuration"
  type = object({
    day          = number
    hour         = number
    update_track = string
  })
}

variable "authorized_networks" {
  description = "List of authorized networks to connect to the instance"
  type = list(object({
    name = string
    cidr = string
  }))
  default = []
}








