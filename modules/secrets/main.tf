resource "google_project_service" "secretmanager" {
  project = var.project_id
  service = "secretmanager.googleapis.com"
}

# Add waiting period after API enablement
resource "time_sleep" "wait_after_api_enable" {
  depends_on      = [google_project_service.secretmanager]
  create_duration = "30s"
}

# Create the secret with automatic replication
resource "google_secret_manager_secret" "db_password" {
  secret_id = "${var.environment}-mysql-password"
  project   = var.project_id

  # Using automatic replication instead of specifying locations
  replication {
    user_managed {
      replicas {
        location = "us-central1" # Using your specified region from variables
      }
    }
  }

  depends_on = [
    google_project_service.secretmanager,
    time_sleep.wait_after_api_enable
  ]
}
resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.database_password

  depends_on = [google_secret_manager_secret.db_password]
}
