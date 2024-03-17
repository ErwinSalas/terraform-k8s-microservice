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
