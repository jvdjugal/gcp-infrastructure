terraform {
  backend "gcs" {
    bucket = "jugal-terraform"
    prefix = "terraform/state"
  }
}

// USe dev environment for this
// Create a bucket in console
//
