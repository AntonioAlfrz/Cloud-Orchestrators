job "Spoti-web" {
	#region = "Europe"
	datacenters = ["Azure"]
	type = "service"
	constraint {
		attribute = "${node.class}"
    value = "Private"
	}
	update {
		stagger = "10s"
		max_parallel = 1
	}
  group "WEB"{
    restart {
			attempts = 3
			interval = "5m"
			delay = "25s"
			mode = "delay"
		}
    task "spoti-web" {
      driver = "docker"
      config {
        image = "aalferez/nomad_web"
        port_map {
          http = 8080
        }
				dns_servers = ["192.168.1.10","192.168.1.11"]
      }
      service {
				name = "webservice"
        port = "http"
        check {
          type = "http"
          path = "/"
          interval = "10s"
          timeout = "2s"
        }
      }
      resources {
				cpu = 500 # 500 Mhz
				memory = 256 # 256MB
        network {
          mbits = 10
          port "http"{} # Dinámico
        }
      }
    }
  }
}
