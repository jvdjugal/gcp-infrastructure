variable "project_id" {
  description = "The project ID where secrets will be stored"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "region" {
  description = "The region where the KMS keyring will be created"
  type        = string
}

variable "database_password" {
  description = "The database password to store in Secret Manager"
  type        = string
  sensitive   = true
}


