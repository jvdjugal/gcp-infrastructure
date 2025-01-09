terraform {
  backend "gcs" {
    bucket = "jugal-tf-bucket"
    prefix = "terraform/state"
  }
}
