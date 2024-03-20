terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.21.0"
    }
  }
}

provider "google" {
  credentials = file("./credentials.json")
  project     = var.project
  region      = var.region
  zone        = var.zone
}

data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "https://${module.gcp_gke.gke_cluster_endpoint}"
  client_certificate     = base64decode(module.gcp_gke.gke_client_certificate)
  client_key             = base64decode(module.gcp_gke.gke_client_key)
  cluster_ca_certificate = base64decode(module.gcp_gke.gke_cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

# provider "kubectl" {
#   host                   = "https://${module.gcp_gke.gke_cluster_endpoint}"
#   client_certificate     = base64decode(module.gcp_gke.gke_client_certificate)
#   client_key             = base64decode(module.gcp_gke.gke_client_key)
#   cluster_ca_certificate = base64decode(module.gcp_gke.gke_cluster_ca_certificate)
#   token                  = data.google_client_config.current.access_token
# }

provider "helm" {
  kubernetes {
    host                   = "https://${module.gcp_gke.gke_cluster_endpoint}"
    token                  = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(module.gcp_gke.gke_cluster_ca_certificate)
  }
}