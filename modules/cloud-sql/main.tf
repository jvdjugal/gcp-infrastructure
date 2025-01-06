# Random suffix for SQL instance name
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

# Create a service account for Cloud SQL
resource "google_service_account" "cloud_sql_sa" {
  account_id   = "cloud-sql-sa-${var.environment}"
  display_name = "Cloud SQL Service Account"
  project      = var.project_id
}

# Database instance
resource "google_sql_database_instance" "instance" {
  name             = "${var.project_id}-${var.environment}-db-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_14"
  project          = var.project_id
  region           = var.region

  depends_on = [var.vpc_connection]

  settings {
    tier              = var.instance_settings.tier
    availability_type = var.instance_settings.availability_type
    disk_size         = var.instance_settings.disk_size
    disk_type         = var.instance_settings.disk_type

    backup_configuration {
      enabled    = var.backup_configuration.enabled
      start_time = var.backup_configuration.start_time
    }

    maintenance_window {
      day          = var.maintenance_window.day
      hour         = var.maintenance_window.hour
      update_track = var.maintenance_window.update_track
    }
  }

  deletion_protection = false # Set to true for production
}

# Create a default database
resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
  project  = var.project_id
}

# Create a user
resource "google_sql_user" "user" {
  name     = var.database_user
  instance = google_sql_database_instance.instance.name
  password = var.database_password
  project  = var.project_id
}
