resource "helm_release" "istiobase" {
  name             = "istiobase"
  namespace        = var.namespace
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = "1.21.0"
  create_namespace = true
  verify           = false
}

resource "helm_release" "istiod" {
  name             = "istiod"
  namespace        = var.namespace
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  version          = "1.21.0"
  create_namespace = true
  verify           = false
  wait             = true

  values = ["${file("${path.module}/values.yaml")}"]

  depends_on = [
    helm_release.istiobase,
  ]
}