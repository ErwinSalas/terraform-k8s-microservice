output "gke_cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "gke_client_certificate" {
  value = google_container_cluster.primary.master_auth.0.client_certificate
}

output "gke_cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

output "gke_client_key" {
  value = google_container_cluster.primary.master_auth.0.client_key
}
