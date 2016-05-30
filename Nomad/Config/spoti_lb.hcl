job "Spoti-lb" {
	region = "Europe"
	datacenters = ["dc1"]
	type = "service"
	priority = 50
	update {
		# Time between updates
		stagger = "10s"
		max_parallel = 1
	}
  group "lb-web"{
		count = 1
		constraint {
			attribute = "${node.class}"
	    value = "Public"
		}
    restart {
			attempts = 3
			interval = "5m"
			# Between restarts
			delay = "25s"
			# Delay the next restart until the next interval is reached
			mode = "delay"
		}
    task "lb-web" {
      driver = "docker"
      config {
        image = "aalferez/haproxy:web"
        port_map {
          http = 8080
        }
				# Need to resolve consul directions
				# Task IP bind = Node IP
				# dns_servers = ["${attr.unique.network.ip-address}"]
				dns_servers = ["172.16.0.4","172.16.0.5"]
      }
      service {
				name = "haproxy-web"
        port = "http"
        check {
          type = "http"
          path = "/health"
          interval = "10s"
          timeout = "2s"
        }
      }
      resources {
        network {
          mbits = 10
          port "http"{
            static = 8080
          }
        }
      }
    }
  }
	group "lb-api"{
		count = 1
		constraint {
			attribute = "${node.class}"
	    value = "Private"
		}
    restart {
			attempts = 3
			interval = "5m"
			# Between restarts
			delay = "25s"
			# Delay the next restart until the next interval is reached
			mode = "delay"
		}
    task "lb-api" {
      driver = "docker"
      config {
        image = "aalferez/haproxy:api"
        port_map {
          http = 3000
        }
				# Need to resolve consul directions ()
				# Task IP bind = Node IP
				# dns_servers = ["${attr.unique.network.ip-address}"]
				dns_servers = ["172.16.0.4","172.16.0.5"]
      }
      service {
				name = "haproxy-api"
        port = "http"
        check {
          type = "http"
          path = "/"
          interval = "10s"
          timeout = "2s"
        }
      }
      resources {
        network {
          mbits = 10
          port "http"{
            static = 3000
          }
        }
      }
    }
  }
}
