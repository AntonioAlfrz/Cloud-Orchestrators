job "jenkins" {
  datacenters = ["dc1"]
  update {
    stagger      = "10s"
    max_parallel = 1
  }
  constraint {
		attribute = "${node.class}"
    value = "Private"
	}
  group "jenkins" {
    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "jenkins" {
      driver = "docker"
      config {
        image = "aalferez/jenkins"
        port_map {
          http = 8080
          jnlp = 50000
        }
        dns_servers = ["172.16.0.4","172.16.0.5"]
      }
      service {
        name = "jenkins"
        port = "http"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
      resources {
        cpu    = 500
        memory = 768
        network {
          mbits = 10
          port "http" {
            static = 8080
          }
          port "jnlp" {
            static = 50000
          }
        }
      }
      kill_timeout = "20s"
    }
  }
}
