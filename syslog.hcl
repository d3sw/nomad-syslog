job "nomad-syslog-test" {
  region      = "us-west-2"
  datacenters = ["us-west-2"]
  type        = "service"

  constraint {
    attribute = "${meta.enclave}"
    value     = "shared"
  }

  group "nomad-syslog-test" {
    count = 1
    task "syslog" {
      driver = "docker"
      env {
        LOG_COUNT    = 2000
        LOG_THREADS  = 4
        LOG_SIZE     = 1024
        LOG_INTERVAL = "5m"
      }
      config {
        labels {
          service   = "nomad-syslog-test"
          component = "nomad-syslog-test"
        }
        # image = "redis"
        # args  = ["bash", "-c", "apt -y update && apt -y install curl && curl -s 'https://raw.githubusercontent.com/ys-zhao/nomad-syslog/main/log.sh' | bash"]
        image = "golang"
        args  = ["bash", "-c", "mkdir /app && cd /app && wget 'https://raw.githubusercontent.com/ys-zhao/nomad-syslog/main/go/main.go' && wget 'https://raw.githubusercontent.com/ys-zhao/nomad-syslog/main/go/go.mod' && wget 'https://raw.githubusercontent.com/ys-zhao/nomad-syslog/main/go/go.sum' && go run main.go"]
        logging {
          type = "syslog"
          config {
            tag = "nomad-syslog-test"
          }
        }
      }
      resources {
        cpu    = 512
        memory = 256
      }
    }
  }
}
