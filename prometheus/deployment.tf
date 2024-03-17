resource "kubernetes_deployment" "deploy" {
  metadata {
    name      = local.name
    namespace = var.istio_ns
    labels    = local.labels
  }

  spec {
    selector {
      match_labels = local.labels
    }

    replicas = 1

    template {
      metadata {
        labels = merge(local.labels, { "sidecar.istio.io/inject" = "false" })
      }

      spec {
        enable_service_links = true
        service_account_name = local.name

        container {
          name              = "prometheus-server-configmap-reload"
          image             = "jimmidyson/configmap-reload:v0.5.0"
          image_pull_policy = "IfNotPresent"
          args = [
            "--volume-dir=/etc/config",
            "--webhook-url=http://127.0.0.1:9090/-/reload"
          ]
          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config"
            read_only  = true
          }
        }

        container {
          name              = "prometheus-server"
          image             = "prom/prometheus:v2.31.1"
          image_pull_policy = "IfNotPresent"
          args = [
            "--storage.tsdb.retention.time=15d",
            "--config.file=/etc/config/prometheus.yml",
            "--storage.tsdb.path=/data",
            "--web.console.libraries=/etc/prometheus/console_libraries",
            "--web.console.templates=/etc/prometheus/consoles",
            "--web.enable-lifecycle"
          ]
          port {
            container_port = 9090
          }

          readiness_probe {
            http_get {
              path   = "/-/ready"
              port   = 9090
              scheme = "HTTP"
            }
            initial_delay_seconds = 0
            period_seconds        = 5
            timeout_seconds       = 4
            failure_threshold     = 3
            success_threshold     = 1
          }

          liveness_probe {
            http_get {
              path   = "/-/healthy"
              port   = 9090
              scheme = "HTTP"
            }

            initial_delay_seconds = 30
            period_seconds        = 15
            timeout_seconds       = 10
            failure_threshold     = 3
            success_threshold     = 1
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config"
          }

          volume_mount {
            name       = "storage-volume"
            mount_path = "/data"
            sub_path   = ""
          }
        }

        host_network = false
        dns_policy   = "ClusterFirst"
        security_context {
          fs_group        = 65534
          run_as_group    = 65534
          run_as_non_root = true
          run_as_user     = 65534
        }

        termination_grace_period_seconds = 300

        volume {
          name = "config-volume"
          config_map {
            name = local.name
          }
        }

        volume {
          name = "storage-volume"
          empty_dir {}
        }
      }
    }
  }
}