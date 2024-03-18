resource "kubernetes_service" "product-db-service" {
  depends_on = [kubernetes_stateful_set_v1.product-db-statefulset]
  metadata {
    name = var.db_label
    labels = {
      app = var.db_label
    }
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.db_label
    }

    port {
      protocol    = "TCP"
      port        = 5237
      target_port = 5237
    }
  }
}

resource "kubernetes_service" "product-service" {
  depends_on = [kubernetes_deployment.product-srv-deployment]
  metadata {
    name      = var.app_label
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_label
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 82
      target_port = 50054 # Expose the port of your auth-service container
    }
  }
}