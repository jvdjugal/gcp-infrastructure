resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend-deployment"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }

      spec {
        container {
          image = "gcr.io/dspl-24-poc/frontend:latest"
          name  = "frontend"

          port { # Corrected from `ports` to `port`
            container_port = 80
          }
        }

        image_pull_secrets {
          name = "gcr-json-key"
        }
      }
    }
  }
}

resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend-deployment"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          image = "gcr.io/dspl-24-poc/backend:latest"
          name  = "backend"

          port { # Corrected from `ports` to `port`
            container_port = 5000
          }
        }

        image_pull_secrets {
          name = "gcr-json-key"
        }
      }
    }
  }
}


resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = "default"
  }
  spec {
    selector = {
      app = "frontend"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend-service"
    namespace = "default"
  }
  spec {
    selector = {
      app = "backend"
    }
    port {
      port        = 5000
      target_port = 5000
    }
  }
}
