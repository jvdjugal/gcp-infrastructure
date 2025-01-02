# modules/apis/outputs.tf

output "enabled_apis" {
  description = "Map of enabled APIs"
  value       = google_project_service.enabled_apis
}

