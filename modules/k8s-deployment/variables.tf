variable "frontend_image" {
  description = "Docker image for the frontend application"
  type        = string
}

variable "backend_image" {
  description = "Docker image for the backend application"
  type        = string
}

variable "frontend_replicas" {
  description = "Number of replicas for the frontend deployment"
  type        = number
  default     = 1
}

variable "backend_replicas" {
  description = "Number of replicas for the backend deployment"
  type        = number
  default     = 1
}

variable "frontend_port" {
  description = "Port number for the frontend service"
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Port number for the backend service"
  type        = number
  default     = 5000
}
