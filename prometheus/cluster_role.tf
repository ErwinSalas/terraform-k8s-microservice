resource "kubernetes_cluster_role" "prometheus" {
  metadata {
    name      = "prometheus"
    labels = {
      component = "server"
      app       = "prometheus"
      heritage  = "Helm"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "cr" {
  metadata {
    name   = local.name
    labels = local.labels
  }

  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }

  rule {
    api_groups = [""]
    resources = [
      "nodes",
      "nodes/proxy",
      "nodes/metrics",
      "services",
      "endpoints",
      "pods",
      "ingresses",
      "configmaps"
    ]
    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = [
      "extensions",
      "networking.k8s.io"
    ]
    resources = [
      "ingresses/status",
      "ingresses"
    ]
    verbs = ["get", "list", "Watch"]
  }
}

resource "kubernetes_cluster_role_binding" "crb" {
  metadata {
    name   = local.name
    labels = local.labels
  }

  subject {
    kind      = "ServiceAccount"
    name      = local.name
    namespace = var.istio_ns
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = local.name
  }
}
