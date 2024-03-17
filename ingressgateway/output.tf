output "lb_ip" {
  value = data.kubernetes_service.lb.status[0].load_balancer[0].ingress[0].ip
}