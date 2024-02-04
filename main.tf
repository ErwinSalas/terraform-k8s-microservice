resource "kubernetes_namespace" "main" {
  metadata {
    name = "k8s-microservices"
    labels = {
      istio-injection = "enabled"
    }
  }
}

module "api" {
  source     = "./api"
  replicas   = 1
  namespace  = kubernetes_namespace.main.metadata[0].name
  app_label  = "api-gateway"
  depends_on = [kubernetes_namespace.main]
}

module "auth" {
  source     = "./auth"
  replicas   = 1
  namespace  = kubernetes_namespace.main.metadata[0].name
  app_label  = "auth-service"
  db_label   = "auth-database"
  depends_on = [kubernetes_namespace.main]
}

module "orders" {
  source     = "./orders"
  replicas   = 1
  namespace  = kubernetes_namespace.main.metadata[0].name
  app_label  = "order-service"
  db_label   = "order-database"
  depends_on = [kubernetes_namespace.main]
}

module "products" {
  source     = "./products"
  replicas   = 1
  namespace  = kubernetes_namespace.main.metadata[0].name
  app_label  = "product-service"
  db_label   = "product-database"
  depends_on = [kubernetes_namespace.main]
}