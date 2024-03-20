locals {
  name = "kiali"
}

variable "istio_ns" {
  type = string
}

variable "ingress_ns" {
  type = string
}

variable "lb" {
  type = string
}

variable "gateway_name" {
  type = string
}