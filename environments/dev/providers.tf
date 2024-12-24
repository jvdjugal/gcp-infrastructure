provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file("/home/jugal/Downloads/dspl-24-poc-0eeb2b70e529.json")
}
