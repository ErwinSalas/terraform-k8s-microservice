resource "helm_release" "istio-ingress" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = "1.13.3"
  verify     = false
  wait       = true

  values = ["${file("${path.module}/values.yaml")}"]
}

data "kubernetes_service" "lb" {
  metadata {
    name      = var.release_name
    namespace = var.namespace
  }

  depends_on = [
    helm_release.istio-ingress
  ]
}