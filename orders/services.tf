resource "kubernetes_service" "order-db-service" {
  depends_on = [ kubernetes_stateful_set_v1.order-db-statefulset ]

  metadata {
    name      = var.db_label
    labels    = {
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
      port        = 5236
      target_port = 5236
    }
  }
}

resource "kubernetes_service" "order-service" {
  depends_on = [ kubernetes_deployment.order-srv-deployment ]
  metadata {
    name      = "order-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_label
    }

    port {
      name       = "grpc"
      protocol   = "TCP"
      port       = 81
      target_port = 50053  # Expose the port of your auth-service container
    }
  }
}