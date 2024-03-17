locals {
  labels = {
    component = "server"
    app       = "prometheus"
  }
  name = "prometheus"
}

variable "istio_ns" {
  type = string
}