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
		count = 2
    restart {
			attempts = 3
			interval = "5m"
			delay = "25s"
			mode = "delay"
		}
    task "spoti-web" {
      driver = "docker"
      config {
        image = "aalferez/nomad_web:2"
        port_map {
          http = 8080
        }
				# Need to resolve consul directions (api.service.consul)
				# Task IP bind = Node IP
				dns_servers = ["${NOMAD_IP_http}"]
      }
			env{
        APIURL="api.service.consul"
				MONGOURL="10.32.0.5:27017"
      }
      service {
				name = "web"
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
