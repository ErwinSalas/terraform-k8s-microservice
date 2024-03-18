resource "kubernetes_service" "auth-db-service" {
  depends_on = [kubernetes_stateful_set_v1.auth-db-statefulset]

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
      port        = 5235
      target_port = 5235
    }
  }
}

resource "kubernetes_service" "auth-service" {
  depends_on = [kubernetes_deployment.auth-srv-deployment]
  metadata {
    name      = "auth-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_label
    }

    port {
      name        = "grpc"
      protocol    = "TCP"
      port        = 83
      target_port = 50051 # Expose the port of your auth-service container
    }
  }
}