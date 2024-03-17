resource "kubernetes_config_map" "prometheus_cm" {
  data = {
    "prometheus.yml" = "${file("${path.module}/prometheus.yaml")}"
  }
  metadata {
    name      = local.name
    namespace = var.istio_ns

    labels = local.labels
  }
}