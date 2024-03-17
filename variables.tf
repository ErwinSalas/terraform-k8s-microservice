variable "project" {
  description = "The GCP project to use."
  default     = "hashicorp-393022"
}

variable "region" {
  description = "The GCP region to deploy to."
  default     = "us-east1"
}

variable "zone" {
  description = "The GCP zone to deploy to."
  default     = "us-east1-b"
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}