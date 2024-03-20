resource "kubernetes_service" "api-gateway-service" {
  metadata {
    name      = "api-gateway-service"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.app_label
    }
    port {
      protocol    = "TCP"
      port        = 8580
      target_port = 3000
    }

    type = "NodePort"
  }
}

resource "kubernetes_manifest" "api_gateway_virtual_service" {
  manifest = {
    apiVersion = "networking.istio.io/v1alpha3"
    kind       = "VirtualService"
    metadata = {
      name      = "api-gateway-vs"
      namespace = var.namespace
    }
    spec = {
      hosts = ["*"]  # Change this to your desired hostname or domain
      gateways = ["${var.gateway_name}"]  # Name of the Istio Ingress Gateway service

      http = [
        {
          match = [
            {
              uri = {
                prefix = "/"
              }
            },
          ]
          route = [
            {
              destination = {
                host = "api-gateway-service.${var.namespace}.svc.cluster.local"  # Name of your service within the cluster
                port = {
                  number = 8580  # Port where your service is exposed
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