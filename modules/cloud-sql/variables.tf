variable "instance_name" {
  description = "Cloud SQL instance name"
  type        = string
}

variable "network_id" {
  description = "The ID of the VPC network for Cloud SQL"
  type        = string
}
variable "region" {
  description = "Region for Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "Version of the database (e.g., POSTGRES_14)"
  type        = string
}

variable "tier" {
  description = "Tier for Cloud SQL instance (e.g., db-f1-micro)"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

# First definition of sql_instances variable (keep this one)
# In modules/cloud-sql/variables.tf
variable "sql_instances" {
  description = "Map of Cloud SQL instance configurations"
  type = map(object({
    region            = string
    database_version  = string
    tier              = string
    backup_start_time = string
    maintenance_window = object({
      day          = number
      hour         = number
      update_track = string
    })
  }))
}


# variables.tf in the cloud-sql module
variable "reserved_peering_ranges" {
  description = "Reserved peering ranges for the VPC connection"
  type        = list(string)
}

# Remove the second declaration of sql_instances
# The duplicate variable declaration (line 50) should be deleted.




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
