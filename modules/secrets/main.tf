# Enable Secret Manager API if not already enabled
resource "google_project_service" "secretmanager" {
  project = var.project_id
  service = "secretmanager.googleapis.com"
}

resource "google_secret_manager_secret" "db_password" {
  secret_id = "${var.environment}-mysql-password"
  project   = var.project_id

  replication {
    user_managed {
      replicas {
        location = "us-central1" # Use a valid region like 'us-central1'
      }
    }
  }

  depends_on = [google_project_service.secretmanager] # Ensure the API is enabled first
}







# Store the secret version
resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.database_password
}
