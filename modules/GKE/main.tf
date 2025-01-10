

# Service Account for GKE Node Pool
resource "google_service_account" "gke_sa" {
  account_id   = "${var.cluster_name}-sa"
  display_name = "GKE Service Account for ${var.cluster_name}"
  project      = var.project_id
}

resource "google_service_account" "bastion_sa" {
  account_id   = "${var.bastion_instance_name}-sa"
  display_name = "Bastion Host Service Account"
  project      = var.project_id
}

resource "google_compute_instance" "bastion" {
  name         = var.bastion_instance_name
  machine_type = var.bastion_machine_type
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = var.bastion_image
    }
  }

  network_interface {
    network    = var.network_id
    subnetwork = var.subnet_id

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = google_service_account.bastion_sa.email
    scopes = ["cloud-platform"]
  }

  tags = var.bastion_tags
}

resource "google_compute_firewall" "iap_to_bastion" {
  name    = var.iap_firewall_name
  network = var.network_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.iap_source_ranges
  target_tags   = var.bastion_tags
}

resource "google_compute_firewall" "iap_to_gke" {
  name    = "${var.cluster_name}-allow-iap"
  network = var.network_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "10250", "15017"] # Required ports for GKE access
  }

  source_ranges = ["35.235.240.0/20"]         # IAP range
  target_tags   = ["gke-${var.cluster_name}"] # Only use target_tags
}



# IAM Role for the GKE Service Account to interact with resources
//give these permission list in .tfvars
# IAM Role bindings for the service account
resource "google_project_iam_member" "gke_sa_permissions" {
  for_each = toset(var.gke_sa_permissions)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}





resource "google_container_cluster" "primary" {
  name       = var.cluster_name
  location   = var.zone
  project    = var.project_id
  network    = var.network_id
  subnetwork = var.subnet_id

  # Enable shielded nodes for additional security
  enable_shielded_nodes = true

  # Maintenance policy for upgrades
  maintenance_policy {
    recurring_window {
      start_time = "2023-01-01T09:00:00Z"
      end_time   = "2023-01-01T17:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=MO,WE,FR"
    }
  }

  # Enable vertical pod autoscaling
  vertical_pod_autoscaling {
    enabled = true
  }

  # Cost management configuration
  cost_management_config {
    enabled = true
  }



  # Addons configuration
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    # DNS cache configuration
    dns_cache_config {
      enabled = true
    }
  }



  # Specify logging and monitoring services
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  # Disable default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block

    master_global_access_config {
      enabled = true
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.authorized_network_cidr
      display_name = "VPC Access"
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
  deletion_protection = false

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



    # Shielded instance configuration for secure VMs
    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }

    # Enable Google Cloud Filestore (optional, set false if not required)
    gcfs_config {
      enabled = true
    }

    service_account = google_service_account.gke_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }


  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}
