output "lb_ip" {
  value = data.kubernetes_service.lb.status[0].load_balancer[0].ingress[0].ip
}

output "gateway_name" {
  value = kubernetes_manifest.api_ingressgateway.manifest.metadata.name
}