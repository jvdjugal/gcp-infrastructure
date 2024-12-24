output "enabled_apis" {
  value = [for api in google_project_service.enabled_apis : api.service]
}
