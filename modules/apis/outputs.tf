# modules/apis/outputs.tf

output "enabled_apis" {
  description = "Map of enabled APIs"
  value       = google_project_service.enabled_apis
}

output "container_api" {
  description = "Container API resource"
  value       = google_project_service.container_api
}

output "compute_api" {
  description = "Compute API resource"
  value       = google_project_service.compute_api
}

output "servicenetworking_api" {
  description = "Service Networking API resource"
  value       = google_project_service.servicenetworking_api
}
