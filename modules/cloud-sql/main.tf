# Declare the private VPC connection for Cloud SQL
# main.tf in the cloud-sql module



locals {
  instances_with_network = {
    for k, v in var.sql_instances : k => merge(v, {
      network_id = var.network_id
    })
  }
}
resource "google_sql_database_instance" "instances" {
  for_each = local.instances_with_network

  name             = each.key
  region           = each.value.region
  database_version = each.value.database_version

  # Remove the depends_on block since we've moved the networking to the VPC module

  settings {
    tier = each.value.tier

    ip_configuration {
      ipv4_enabled    = false
      private_network = each.value.network_id
    }

    # Rest of your settings configuration...
  }

  deletion_protection = false
}

resource "google_sql_database" "databases" {
  for_each = { for db_key, db_config in local.all_databases : db_key => db_config }

  name     = each.value.name
  instance = google_sql_database_instance.instances[each.value.instance_name].name
}

resource "random_password" "user_passwords" {
  for_each = { for user_key, user_config in local.all_users : user_key => user_config }

  length  = 16
  special = true
}

resource "google_sql_user" "users" {
  for_each = { for user_key, user_config in local.all_users : user_key => user_config }

  name     = each.value.name
  instance = google_sql_database_instance.instances[each.value.instance_name].name
  password = random_password.user_passwords[each.key].result
}

locals {
  all_databases = flatten([
    for instance_name, config in local.instances_with_network : [
      for db in var.sql_databases : {
        instance_name = instance_name
        name          = db.name
      }
    ]
  ])

  all_users = flatten([
    for instance_name, config in local.instances_with_network : [
      for user in var.sql_users : {
        instance_name = instance_name
        name          = user.name
      }
    ]
  ])
}

