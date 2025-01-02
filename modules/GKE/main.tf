

# Service Account for GKE Node Pool
resource "google_service_account" "gke_sa" {
  account_id   = "${var.cluster_name}-sa"
  display_name = "GKE Service Account for ${var.cluster_name}"
  project      = var.project_id
}

# IAM Role for the GKE Service Account to interact with resources
//give these permission list in .tfvars
resource "google_project_iam_member" "gke_sa_permissions" {
  for_each = { for idx, perm in var.gke_sa_permissions : idx => perm }

  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}




resource "google_container_cluster" "primary" {
  name       = var.cluster_name
  location   = var.zone
  project    = var.project_id
  network    = var.network_id
  subnetwork = var.subnet_id

  # Disable default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true #This is used to disable public IP  
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.authorized_network_cidr
      display_name = "VPC"
    }
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  dns_config {
    cluster_dns        = "CLOUD_DNS"
    cluster_dns_scope  = "VPC_SCOPE"
    cluster_dns_domain = "cluster.local"
  }

  release_channel {
    channel = "REGULAR"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "${var.cluster_name}-node-pool"
  location = var.zone
  cluster  = google_container_cluster.primary.name
  project  = var.project_id

  node_count = var.primary_node_count

  autoscaling {
    min_node_count = var.autoscaling_min_node_count # Use variable for min nodes
    max_node_count = var.autoscaling_max_node_count # Use variable for max nodes
  }

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size_gb
    disk_type    = var.node_disk_type

    service_account = google_service_account.gke_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
