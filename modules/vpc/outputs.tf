output "network_ids" {
  description = "Map of VPC names to their IDs"
  value       = { for name, vpc in google_compute_network.vpc : name => vpc.id }
}

output "network_names" {
  description = "Map of VPC names"
  value       = { for name, vpc in google_compute_network.vpc : name => vpc.name }
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = { for name, subnet in google_compute_subnetwork.subnets : name => subnet.id }
}

output "network_id" {
  description = "The ID of the primary VPC network"
  value       = google_compute_network.vpc["my-vpc"].id
}
variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
}




