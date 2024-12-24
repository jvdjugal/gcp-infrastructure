output "network_id" {
  description = "The ID of the created VPC network"
  value       = google_compute_network.vpc.id
}

output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.id }
}
// chmod 600 /path/to/your-service-account-key.json
