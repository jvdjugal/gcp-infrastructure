variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "zone" {
  description = "The zone to host the cluster in"
  type        = string
}

variable "network_id" {
  description = "The VPC network ID to host the cluster in"
  type        = string
}

variable "subnet_id" {
  description = "The subnetwork ID to host the cluster in"
  type        = string
}


variable "pods_range_name" {
  description = "The name of the secondary IP range for pods"
  type        = string
}

variable "services_range_name" {
  description = "The name of the secondary IP range for services"
  type        = string
}

variable "node_machine_type" {
  description = "The machine type for the GKE nodes."
  type        = string
  default     = "e2-micro"
}

variable "node_disk_size_gb" {
  description = "The disk size (in GB) for the GKE nodes."
  type        = number
  default     = 20
}

variable "node_disk_type" {
  description = "The disk type for the GKE nodes."
  type        = string
  default     = "pd-standard"
}

variable "primary_node_count" {
  description = "The initial number of nodes in the node pool."
  type        = number
  default     = 1
}

variable "autoscaling_min_node_count" {
  description = "The minimum number of nodes for autoscaling."
  type        = number
  default     = 1
}

variable "autoscaling_max_node_count" {
  description = "The maximum number of nodes for autoscaling."
  type        = number
  default     = 2
}



variable "gke_sa_permissions" {
  description = "List of IAM roles to assign to the GKE service account."
  type        = list(string)

}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation for the GKE master network"
  type        = string
}
