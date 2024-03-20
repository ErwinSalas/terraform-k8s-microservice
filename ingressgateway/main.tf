resource "helm_release" "istio-ingress" {
  name       = var.release_name
  namespace  = var.namespace
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = "1.21.0"
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

# not working due to https://github.com/hashicorp/terraform-provider-kubernetes/issues/1929
resource "kubernetes_manifest" "api_ingressgateway" {
  manifest = {
    kind       = "Gateway"
    apiVersion = "networking.istio.io/v1alpha3"
    metadata = {
      name      = "api-ingressgateway"
      namespace = "k8s-microservices"
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
        {
          port = {
            number   = 80
            name     = "http"
            protocol = "HTTP"
          }
          hosts = ["*"]
        },
        {
          port = {
            number   = 20002
            name     = "api"
            protocol = "HTTP"
          }
          hosts = ["*"]
        }
      ]
    }
  }
  depends_on = [ helm_release.istio-ingress ]
}

resource "kubernetes_manifest" "istio_ingressgateway" {
  manifest = {
    kind       = "Gateway"
    apiVersion = "networking.istio.io/v1alpha3"
    metadata = {
      name      = "istio-ingressgateway"
      namespace = "istio-system"
    }
    spec = {
      selector = {
        istio = "ingressgateway"
      }
      servers = [
        {
          port = {
            number   = 80
            name     = "http"
            protocol = "HTTP"
          }
          hosts = ["*"]
        },
        {
          port = {
            number   = 20001
            name     = "kiali"
            protocol = "HTTP"
          }
          hosts = ["*"]
        }
      ]
    }
  }
  depends_on = [ helm_release.istio-ingress ]
}

# resource "kubernetes_manifest" "api-gateway" {
#   manifest = yamldecode("${file("${path.module}/api-gateway.yaml")}")
# }

# resource "kubernetes_manifest" "istio-gateway" {
#   manifest = yamldecode("${file("${path.module}/istio-gateway.yaml")}")
# }