resource "kubernetes_ingress_v1" "api-gateway-ingress" {
  metadata {
    name      = "api-gateway-ingress"
    namespace = var.namespace
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    default_backend {
      service {
        name = kubernetes_service.api-gateway-service.metadata[0].name
        port {
          number = 8580
        }
      }
    }
    rule {
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service.api-gateway-service.metadata[0].name
              port {
                number = 8580
              }
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "api-gateway-service" {
  metadata {
    name = "api-gateway-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.app_label
    }
    port {
      protocol = "TCP"
      port        = 8580
      target_port = 3000
    }

    type = "NodePort"
  }
}
