variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "apis" {
  description = "List of APIs to enable"
  type        = list(string)
}
