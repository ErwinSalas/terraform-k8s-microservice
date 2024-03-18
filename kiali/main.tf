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

resource "kubernetes_manifest" "kiali_vs" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "VirtualService"
    metadata = {
      name      = "kiali"
      namespace = var.istio_ns  # Cambia esto según el namespace donde esté desplegado Istio
    }
    spec = {
      hosts = ["*"]  # Cambia esto por el dominio o hostname que deseas usar para acceder a Kiali
      gateways = ["istio-ingressgateway"]  # Nombre del Service de Istio Ingress Gateway
      http = [{
        route = [{
          destination = {
            host = "kiali.istio-system.svc.cluster.local"  # Nombre del servicio de Kiali dentro de tu clúster
            port = {
              number = 20001  # Puerto donde se sirve el dashboard de Kiali
            }
          }
        }]
      }]
    }
  }
}
