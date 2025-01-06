output "db_password_secret_id" {
  description = "The Secret ID of the database password"
  value       = google_secret_manager_secret.db_password.id
}
