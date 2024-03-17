resource "kubernetes_config_map" "cm" {
  metadata {
    name      = local.name
    namespace = var.istio_ns
    labels = {
      "app" = local.name
    }
  }

  data = {
    "config.yaml" = "${templatefile("${path.module}/config.yaml", { lb = var.lb } )}"
  }
}