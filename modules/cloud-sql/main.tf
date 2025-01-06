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

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = "db-f1-micro" # Smallest available machine type
    availability_type = "ZONAL"       # Use ZONAL for development to reduce costs
    disk_size         = 10            # Minimum disk size in GB
    disk_type         = "PD_SSD"      # Using SSD for better performance

    ip_configuration {
      ipv4_enabled    = false # Disable public IP
      private_network = var.network_id

      # Add authorized networks if needed
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.cidr
        }
      }
    }

    backup_configuration {
      enabled    = true
      start_time = "23:00" # 11 PM UTC
    }

    maintenance_window {
      day          = 1 # Monday
      hour         = 4 # 4 AM
      update_track = "stable"
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
