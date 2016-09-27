job "Spoti-web" {
	region = "Europe"
	datacenters = ["dc1"]
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
				# Need to resolve consul directions (api.service.consul) in container
				# Task IP bind = Node IP
				# dns_servers = ["${attr.unique.network.ip-address}"]
				dns_servers = ["8.8.8.8","8.8.4.4","172.16.0.4","172.16.0.5"]
      }
			env{
        APIURL="haproxy-api.service.consul:3000"
				MONGOURL="MONGO_URL:27017"
      }
      service {
				name = "web"
        port = "http"
        check {
          type = "tcp"
          interval = "10s"
          timeout = "2s"
        }
      }
      resources {
				cpu = 500
				memory = 128
        network {
          mbits = 10
          port "http"{} # Dinámico
        }
      }
    }
  }
}
