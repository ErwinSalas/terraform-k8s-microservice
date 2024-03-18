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

resource "tls_private_key" "my_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "my_self_signed_cert" {
  private_key_pem       = tls_private_key.my_private_key.private_key_pem
  validity_period_hours = 8760  # Validez del certificado: 1 año (8760 horas)
  allowed_uses          = ["digital_signature", "key_encipherment"]
}



resource "kubernetes_secret" "my_tls_secret" {
  metadata {
    name      = "my-tls-secret"
    namespace = var.namespace
  }

  data = {
    "tls.crt" = tls_self_signed_cert.my_self_signed_cert.cert_pem
    "tls.key" = tls_private_key.my_private_key.private_key_pem
  }
}