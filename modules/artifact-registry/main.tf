resource "google_artifact_registry_repository" "my_app_repo" {
  repository_id = var.repository_id
  location      = var.location
  description   = var.description
  format        = var.format

}


//docker pull us-central1-docker.pkg.dev/dspl-24-poc/frontend-repo/frontend:latest
