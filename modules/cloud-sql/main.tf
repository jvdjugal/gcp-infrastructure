

# Random suffix for SQL instance name
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

# MySQL instance
resource "google_sql_database_instance" "instance" {
  name             = "${var.project_id}-${var.environment}-mysql-${random_id.db_name_suffix.hex}"
  database_version = "MYSQL_8_0" # Using MySQL 8.0
  project          = var.project_id
  region           = var.region

  depends_on = [var.vpc_connection]

  settings {
    tier              = var.instance_settings.tier
    availability_type = var.instance_settings.availability_type
    disk_size         = var.instance_settings.disk_size
    disk_type         = var.instance_settings.disk_type

    # MySQL-specific settings
    database_flags {
      name  = "slow_query_log"
      value = "on"
    }

    database_flags {
      name  = "long_query_time"
      value = "1"
    }

    ip_configuration {
      ipv4_enabled    = false # Disable public IP
      private_network = var.network_id

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.cidr
        }
      }
    }

    backup_configuration {
      enabled            = var.backup_configuration.enabled
      start_time         = var.backup_configuration.start_time
      binary_log_enabled = true # Enable binary logging for point-in-time recovery
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
  name      = var.database_name
  instance  = google_sql_database_instance.instance.name
  project   = var.project_id
  charset   = "utf8mb4" # MySQL-specific charset
  collation = "utf8mb4_general_ci"
}

# Create a user
resource "google_sql_user" "user" {
  name     = var.database_user
  instance = google_sql_database_instance.instance.name
  password = data.google_secret_manager_secret_version.db_password.secret_data
  project  = var.project_id
  host     = "%"
}

data "google_secret_manager_secret_version" "db_password" {
  secret  = var.database_password_secret_id
  project = var.project_id
}
