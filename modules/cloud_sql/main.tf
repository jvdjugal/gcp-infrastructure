resource "google_compute_global_address" "private_ip_address" {
  project       = var.project_id
  name          = "${var.instance_name}-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]

  depends_on = [google_compute_global_address.private_ip_address]

  lifecycle {
    create_before_destroy = true
  }
}


resource "google_sql_database_instance" "instance" {
  project          = var.project_id
  name             = var.instance_name
  region           = var.region
  database_version = var.database_version

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = var.tier
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.network_id
      enable_private_path_for_google_cloud_services = true
    }

    backup_configuration {
      enabled                        = true
      binary_log_enabled             = true
      start_time                     = "23:00"
      transaction_log_retention_days = 7
    }

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.value["name"]
        value = database_flags.value["value"]
      }
    }
  }

  deletion_protection = false
}
