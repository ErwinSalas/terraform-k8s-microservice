resource "kubernetes_service" "svc" {
  metadata {
    labels    = local.labels
    name      = local.name
    namespace = var.istio_ns
  }

  spec {
    selector = local.labels
    port {
      name        = "http"
      port        = 9090
      protocol    = "TCP"
      target_port = 9090
    }
    session_affinity = "None"
    type             = "ClusterIP"
  }
}
