# Service Account for GKE
resource "google_service_account" "gke_sa" {
  account_id   = "${var.cluster_name}-sa"
  display_name = "GKE Service Account for ${var.cluster_name}"
  project      = var.project_id
}

# Backend Service Account for Workload Identity
resource "google_service_account" "backend_sa" {
  account_id   = "backend-sa"
  display_name = "Backend Service Account"
  project      = var.project_id

  lifecycle {
    ignore_changes = [display_name]
  }
}

# IAM roles for GKE Service Account
resource "google_project_iam_member" "gke_sa_roles" {
  for_each = toset([
    "roles/container.nodeServiceAccount",
    "roles/storage.objectViewer",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/logging.logWriter",
    "roles/compute.networkUser",
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# IAM role for Backend Service Account
resource "google_project_iam_member" "backend_sa_cloudsql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.backend_sa.email}"
}

# Workload Identity IAM binding
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.backend_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/backend-sa]"
  ]
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name                = var.cluster_name
  location            = var.region
  project             = var.project_id
  deletion_protection = false # Disable to allow Terraform to destroy

  network    = var.network_id
  subnetwork = var.vpc_module.subnet_ids["${var.network_name}-${var.subnet_name}"]

  initial_node_count = 1

  node_config {
    disk_type       = "pd-standard" # Explicitly use standard persistent disk
    disk_size_gb    = 100           # Set an appropriate size
    machine_type    = "e2-medium"   # Or whatever machine type you prefer
    service_account = google_service_account.gke_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Enable network policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_range_name
    services_secondary_range_name = var.service_range_name
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    network_policy_config {
      disabled = false
    }
  }
}

# Node Pools - Default Pool
variable "node_pools" {
  description = "List of node pool configurations"
  type = list(object({
    name         = string
    machine_type = string
    disk_size_gb = number
    node_count   = number
    min_count    = number
    max_count    = number
    node_version = string
    image_type   = string
    labels       = map(string)
  }))
}

# Then, update the node pool resource in main.tf
resource "google_container_node_pool" "pools" {
  name               = "default-pool"
  location           = var.region
  cluster            = google_container_cluster.primary.name
  project            = var.project_id
  initial_node_count = 1

  node_config {
    machine_type    = "e2-medium"
    disk_type       = "pd-standard"
    disk_size_gb    = 100
    image_type      = "COS_CONTAINERD"
    service_account = google_service_account.gke_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}



# Generate a random suffix for node pools (optional)
resource "random_id" "node_suffix" {
  byte_length = 4
}
