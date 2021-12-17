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
        LOG_ITEMS   = 2000
        LOG_THREADS = 4
      }
      config {
        labels {
          service   = "${NOMAD_JOB_NAME}"
          component = "${NOMAD_TASK_NAME}"
        }
        # image = "redis"
        # args  = ["bash", "-c", "apt -y update && apt -y install curl && curl -s 'https://raw.githubusercontent.com/ys-zhao/nomad-syslog/main/log.sh' | bash"]
        image = "golang"
        args  = ["bash", "-c", "apt -y update && apt -y install curl && curl -s 'https://raw.githubusercontent.com/ys-zhao/nomad-syslog/main/go/main.go' && go mod init && go mod tidy && go run main.go"]
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
