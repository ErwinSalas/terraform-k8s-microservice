resource "helm_release" "kiali" {
  name       = "kiali-server"
  repository = "https://kiali.org/helm-charts"
  chart      = "kiali-server"
  version    = "1.81.0"
  namespace  = var.istio_ns

  values = [
    templatefile("${path.module}/values.yaml", {
      istio_ns   = var.istio_ns
      ingress_ns = var.ingress_ns
      lb         = var.lb
    })
  ]
}

resource "kubernetes_manifest" "kiali_virtual_service" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "VirtualService"
    metadata = {
      name      = "kiali-vs"
      namespace = var.istio_ns
    }
    spec = {
      hosts = ["*"]  # Change this to your desired hostname or domain
      gateways = ["istio-ingressgateway"]  # Name of the Istio Ingress Gateway service

      http = [
        {
          match = [
            {
              port = 20001
            }
          ]
          route = [
            {
              destination = {
                host = "kiali.${var.istio_ns}.svc.cluster.local"  # Name of your Kiali service within the cluster
                port = {
                  number = 20001  # Port where Kiali is exposed
                }
              }
            }
          ]
        }
      ]
    }
  }
}

# resource "kubernetes_manifest" "virtual-service" {
#   manifest = yamldecode("${file("${path.module}/virtual-service.yaml")}")
# }