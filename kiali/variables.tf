locals {
  name = "kiali"
}

variable "istio_ns" {
  type = string
}

variable "lb" {
  type = string
}