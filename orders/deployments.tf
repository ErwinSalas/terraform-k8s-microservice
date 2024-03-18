resource "kubernetes_deployment" "order-srv-deployment" {
  depends_on = [kubernetes_service.order-db-service]

  metadata {
    name = "order-srv-deployment"
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
          image = "erwinsalas42/go-grpc-order-svc:v1"
          name  = "go-grpc-order-svc"

          env {
            name  = "PORT"
            value = ":50053"
          }
          env {
            name  = "DB_URL"
            value = "postgres://erwin:password@order-database.k8s-microservices:5236/order"
          }
          env {
            name  = "PRODUCT_SVC_URL"
            value = "product-service.k8s-microservices:82"
          }

          port {
            container_port = 50053
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

resource "kubernetes_stateful_set_v1" "order-db-statefulset" {
  metadata {
    name = "order-db-statefulset"
    labels = {
      app = var.db_label
    }
    namespace = var.namespace
  }

  spec {
    service_name = "order-db-statefulset"
    replicas     = 1

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
          name  = "order-database"

          args = ["-p", "5236"]

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
            value = "order"
          }

          port {
            container_port = 5236
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

