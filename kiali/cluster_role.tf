resource "kubernetes_cluster_role" "cr_viewer" {
  metadata {
    name = "kiali-viewer"
    labels = {
      "app" = local.name
    }
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "pods/log"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods", "replicationcontrollers", "services"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/portforward"]
    verbs      = ["create", "post"]
  }

  rule {
    api_groups = ["extensions", "apps"]
    resources  = ["daemonsets", "deployments", "replicasets", "statefulsets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["networking.istio.io", "security.istio.io"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["iter8.tools"]
    resources  = ["experiments"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
    verbs      = ["create"]
  }
}

resource "kubernetes_cluster_role" "cr" {
  metadata {
    name = local.name
    labels = {
      "app" = local.name
    }
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "pods/log"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods", "replicationcontrollers", "services"]
    verbs      = ["get", "list", "watch", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/portforward"]
    verbs      = ["create", "post"]
  }

  rule {
    api_groups = ["extensions", "apps"]
    resources  = ["daemonsets", "deployments", "replicasets", "statefulsets"]
    verbs      = ["get", "list", "watch", "patch"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["get", "list", "watch", "patch"]
  }

  rule {
    api_groups = ["networking.istio.io", "security.istio.io"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "create", "delete", "patch"]
  }

  rule {
    api_groups = ["iter8.tools"]
    resources  = ["experiments"]
    verbs      = ["get", "list", "watch", "create", "delete", "patch"]
  }

  rule {
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
    verbs      = ["create"]
  }
}

resource "kubernetes_cluster_role_binding" "crb_kiali" {
  metadata {
    name = local.name
    labels = {
      app = local.name
    }
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

resource "kubernetes_role" "role_kiali_controlplane" {
  metadata {
    name      = "kiali-controlplane"
    namespace = var.istio_ns
    labels = {
      app = local.name
    }
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["list"]
  }

  rule {
    api_groups     = [""]
    resource_names = ["cacerts", "istio-ca-secret"]
    resources      = ["secrets"]
    verbs          = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "rb" {
  metadata {
    name      = "kiali-controlplane"
    namespace = var.istio_ns
    labels = {
      app = local.name
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = local.name
    namespace = var.istio_ns
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "kiali-controlplane"
  }
}