provider "google" {
  credentials = file("/home/jugal/Downloads/dspl-24-poc-b992e28073cc.json")
  project     = var.project_id
  region      = var.region
}

provider "kubernetes" {
  config_path    = "~/.kube/config"                                          # Path to kubeconfig file
  config_context = "gke_${var.project_id}_${var.region}_${var.cluster_name}" # Replace with your actual context
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20.0" # Adjust version as needed
    }
  }
}
