job "Spoti-lb" {
	#region = "Europe"
	datacenters = ["Azure"]
	type = "service"
	constraint {
		attribute = "${node.class}"
    value = "Public"
	}
	update {
		stagger = "10s"
		max_parallel = 1
	}
  group "LB"{
		count = 2
    restart {
			attempts = 3
			interval = "5m"
			delay = "25s"
			mode = "delay"
		}
    task "spoti-lb" {
      driver = "docker"
      config {
        image = "aalferez/haproxy"
        port_map {
          http = 3000
        }
				# Need to resolve consul directions ()
				# Task IP bind = Node IP
				dns_servers = ["${NOMAD_IP_http}"]
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
          port "http"{
            static = 3000
          } # Dinámico
        }
      }
    }
  }
}
