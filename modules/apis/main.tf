resource "google_project_service" "enabled_apis" {
  for_each = toset(var.apis)

  project = var.project_id
  service = each.value
}
resource "google_project_service" "container_api" {
  service = "container.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "compute_api" {
  service                    = "compute.googleapis.com"
  project                    = var.project_id
  disable_dependent_services = true # Ensure that dependent services are disabled
}


