# modules/apis/main.tf
# Single resource to handle all APIs using for_each
resource "google_project_service" "enabled_apis" {
  for_each = toset(var.apis)

  project                    = var.project_id
  service                    = each.value
  disable_on_destroy         = true
  disable_dependent_services = true

  timeouts {
    create = "30m"
    delete = "30m"
  }
}
