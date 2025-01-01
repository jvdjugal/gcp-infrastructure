variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "dev-cluster" # Replace with your actual cluster name
}
variable "location" {
  description = "The region where the GKE cluster will be deployed."
  type        = string
  default     = "us-central1" # You can replace this with your desired region
}

variable "project_id" {
  description = "The project ID where the cluster will be created"
  type        = string
  default     = "dspl-24-poc"
}

variable "region" {
  description = "The region where the cluster will be created"
  type        = string
}

variable "network_id" {
  description = "The ID of the network to use for the cluster"
  type        = string
}

# variables.tf in gke module



variable "master_ipv4_cidr_block" {
  description = "The CIDR block for the GKE master nodes"
  type        = string
}

variable "pod_range_name" {
  description = "The secondary range name for pods"
  type        = string
}

variable "service_range_name" {
  description = "The secondary range name for services"
  type        = string
}

variable "environment" {
  description = "The environment label for the resources (e.g., dev, prod)"
  type        = string
}
variable "node_location" {
  description = "The zone where the GKE node pool will be deployed."
  type        = string
  default     = "us-central1-a" # Replace with your desired zone for node pool
}




variable "vpc_module" {
  description = "VPC module output"
  type        = any
}

# Rest of your variables remain the same...

# modules/gke/variables.tf
variable "service_account_id" {
  description = "The ID of the service account for GKE nodes"
  type        = string
  default     = "terraform-sa"
}



variable "image_type" {
  description = "The image type for the node pool"
  default     = "COS_CONTAINERD"
}
variable "subnet_name" {
  description = "The name of the subnet to use for the GKE cluster"
  type        = string
}
variable "network_name" {
  description = "The name of the network"
  type        = string
}

variable "gke_service_account" {
  description = "The service account email for GKE nodes"
  type        = string
}

variable "workload_identity_pool" {
  description = "The Workload Identity Pool"
  type        = string
  default     = null
}

variable "workload_identity_namespace" {
  description = "The Kubernetes namespace for workload identity"
  type        = string
  default     = "default"
}

