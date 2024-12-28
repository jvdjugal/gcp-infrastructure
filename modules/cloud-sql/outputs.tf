output "instance_names" {
  description = "Map of Cloud SQL instance names"
  value = {
    for k, v in google_sql_database_instance.instances : k => v.name
  }
}

output "database_names" {
  description = "Map of database names by instance"
  value = {
    for k, v in google_sql_database.databases : k => v.name
  }
}

output "user_names" {
  description = "Map of user names by instance"
  value = {
    for k, v in google_sql_user.users : k => v.name
  }
}
