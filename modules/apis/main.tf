# modules/apis/main.tf

# For handling APIs from the variable list
resource "google_project_service" "enabled_apis" {
  for_each = toset(var.apis)

  project                    = var.project_id
  service                    = each.value
  disable_on_destroy         = true
  disable_dependent_services = true

  # Add timeouts to handle long enable/disable operations
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

# For Container API
resource "google_project_service" "container_api" {
  project                    = var.project_id
  service                    = "container.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

# For Compute API
resource "google_project_service" "compute_api" {
  project                    = var.project_id
  service                    = "compute.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

# Additional essential APIs that might be needed for VPC
resource "google_project_service" "servicenetworking_api" {
  project                    = var.project_id
  service                    = "servicenetworking.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true

  timeouts {
    create = "30m"
    delete = "30m"
  }
}
