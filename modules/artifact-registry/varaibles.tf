variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
}

variable "repository_id" {
  description = "ID of the Artifact Registry repository"
  type        = string
}

variable "location" {
  description = "Location for the Artifact Registry repository"
  type        = string
}

variable "description" {
  description = "Description of the Artifact Registry repository"
  type        = string
  default     = "Artifact Registry repository"
}

variable "format" {
  description = "Format of the Artifact Registry repository (e.g., DOCKER, MAVEN)"
  type        = string
  default     = "DOCKER"
}
