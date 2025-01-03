variable "project_id" {
  description = "The project ID where the Cloud SQL instance will be created"
  type        = string
}

variable "region" {
  description = "The region where the Cloud SQL instance will be created"
  type        = string
}

variable "instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "The database version to use"
  type        = string
  default     = "MYSQL_8_0"
}

variable "network_id" {
  description = "The VPC network ID to connect the instance to"
  type        = string
}

variable "tier" {
  description = "The machine type to use"
  type        = string
  default     = "db-f1-micro"
}

variable "database_flags" {
  description = "List of Cloud SQL flags that are applied to the database server"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
