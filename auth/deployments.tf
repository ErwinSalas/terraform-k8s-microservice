resource "kubernetes_deployment" "auth-srv-deployment" {
  depends_on = [kubernetes_service.auth-db-service]

  metadata {
    name = "auth-srv-deployment"
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
          image = "erwinsalas42/go-grpc-auth-svc:v1.1"
          name  = "go-grpc-auth-svc"

          env {
            name  = "PORT"
            value = ":50051"
          }
          // auth-database:5235 represents the service name:port
          env {
            name  = "DB_URL"
            value = "postgres://erwin:password@auth-database.k8s-microservices:5235/auth"
          }
          env {
            name  = "JWT_SECRET_KEY"
            value = "r43t18sc"
          }
          env {
            name     = "API_SECRET"
            value = "98hbun98h"
          }

          port {
            container_port = 50051
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

resource "kubernetes_stateful_set_v1" "auth-db-statefulset" {
  metadata {
    name = "auth-db-statefulset"
    labels = {
      app = var.db_label
    }
    namespace = var.namespace
  }

  spec {
    service_name = "auth-db-statefulset"

    replicas = 1
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
          name  = "auth-database"
          args = [ "-p", "5235" ]

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
            value = "auth"
          }

          port {
            container_port = 5235
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
