resource "kubernetes_deployment" "api-gateway-deployment" {
  metadata {
    name = "grpc-api-gateway"
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
          image = "erwinsalas42/go-grpc-api-gateway:v1"
          name  = "go-grpc-api-gateway"

          env {
            name  = "PORT"
            value = ":3000"
          }
          env {
            name  = "AUTH_SVC_URL"
            value = "auth-service.k8s-microservices:83"
          }
          env {
            name  = "PRODUCT_SVC_URL"
            value = "product-service.k8s-microservices:82"
          }
          env {
            name  = "ORDER_SVC_URL"
            value = "order-service.k8s-microservices:81"
          }


          port {
            container_port = 3000
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