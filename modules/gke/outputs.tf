# modules/gke/outputs.tf
output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.primary.endpoint
}

output "gke_sa_email" {
  value = google_service_account.gke_sa.email
}

output "backend_sa_email" {
  value = google_service_account.backend_sa.email
}
