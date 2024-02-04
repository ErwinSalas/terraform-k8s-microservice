resource "kubernetes_deployment" "product-srv-deployment" {
  depends_on = [kubernetes_service.product-db-service]

  metadata {
    name = "product-srv-deployment"
    labels = {
      app = var.app_label
    }
    namespace = var.namespace
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_label
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_label
        }
      }

      spec {
        container {
          image = "erwinsalas42/go-grpc-product-svc:v1.1"
          name  = "product-service"

          env {
            name  = "PORT"
            value = ":50054"
          }
          env {
            name  = "DB_URL"
            value = "postgres://erwin:password@product-database.k8s-microservices:5237/product"
          }
        
          port {
            container_port = 50054
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_stateful_set_v1" "product-db-statefulset" {
  metadata {
    name = "product-db-statefulset"
    labels = {
      app = var.db_label
    }
    namespace = var.namespace
  }

  spec {
    service_name = "product-db-statefulset"

    replicas = var.replicas

    selector {
      match_labels = {
        app = var.db_label
      }
    }

    template {
      metadata {
        labels = {
          app = var.db_label
        }
      }

      spec {
        container {
          image = "postgres:latest"
          name  = "product-database"

          args = ["-p", "5237"]

          env {
            name  = "POSTGRES_USER"
            value = "erwin"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "password"
          }
          env {
            name  = "POSTGRES_DB"
            value = "product"
          }

          port {
            container_port = 5237
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}