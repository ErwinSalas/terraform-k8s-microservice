resource "kubernetes_service_account" "sa" {
  metadata {
    name      = local.name
    namespace = var.istio_ns

    labels = local.labels
  }
}