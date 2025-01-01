terraform {
  backend "gcs" {
    bucket      = "jugal-tf-bucket"
    prefix      = "terraform/state"
    credentials = "key.json"
  }
}

// USe dev environment for this
// Create a bucket in console
//
