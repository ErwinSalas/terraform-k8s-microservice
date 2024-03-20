# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.cidr_range
}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.vpc.name
  priority    = 998  # Adjust the priority value as needed

  allow {
    protocol = "tcp"
    ports    = ["80","20001", "20002"]
  }

  source_ranges = ["0.0.0.0/0"]  # CIDR range to allow all external ips
}