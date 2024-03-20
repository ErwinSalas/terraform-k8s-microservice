resource "kubernetes_namespace" "main" {
  metadata {
    name = "k8s-microservices"
    labels = {
      istio-injection = "enabled"
    }
  }

  depends_on = [module.gcp_gke]
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "istio-ingress"
  }

  depends_on = [module.gcp_gke]
}

resource "kubernetes_namespace" "istiosystem" {
  metadata {
    name = "istio-system"
  }

  depends_on = [module.gcp_gke]
}

module "api" {
  source     = "./api"
  replicas   = 1
  istio_ns = kubernetes_namespace.ingress.metadata[0].name
  namespace  = kubernetes_namespace.main.metadata[0].name
  app_label  = "api-gateway"
  gateway_name = module.istio-ingressgateway.gateway_name
  depends_on = [
    kubernetes_namespace.main, 
    module.istio,
  ]
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

module "gcp_vpc" {
  source     = "./vpc"
  cidr_range = "10.10.0.0/24"
  region     = var.region
  project    = var.project
  zone       = var.zone
}


module "gcp_gke" {
  source        = "./gke"
  gke_num_nodes = 2
  region        = var.region
  project       = var.project
  zone          = var.zone
  vpc_name      = module.gcp_vpc.vpc_name
  subnet_name   = module.gcp_vpc.subnet_name
  depends_on    = [module.gcp_vpc]
}


module "istio" {
  source    = "./istio"
  namespace = kubernetes_namespace.istiosystem.metadata[0].name
  depends_on = [
    kubernetes_namespace.istiosystem
  ]
}

module "istio-ingressgateway" {
  source = "./ingressgateway"

  release_name = "istio-ingressgateway"
  namespace    = kubernetes_namespace.ingress.metadata[0].name

  depends_on = [
    module.istio,
    kubernetes_namespace.ingress
  ]
}

module "kiali" {
  source     = "./kiali"
  istio_ns   = kubernetes_namespace.istiosystem.metadata[0].name
  ingress_ns = kubernetes_namespace.ingress.metadata[0].name
  lb         = module.istio-ingressgateway.lb_ip
  gateway_name = module.istio-ingressgateway.gateway_name

  depends_on = [
    module.istio,
    module.istio-ingressgateway,
    kubernetes_namespace.istiosystem
  ]
}
