job "Spoti_db" {
	#region = "Europe"
	datacenters = ["Azure"]
	type = "service"
	update {
		stagger = "10s"
		max_parallel = 1
	}
  group "DB"{
    restart {
			attempts = 3
			interval = "5m"
			delay = "25s"
			mode = "delay"
		}
    task "spoti-db" {
      driver = "docker"
      config {
        image = "mongo"
        port_map {
          http = 27017
        }
      }
      service {
        name = "mongo"
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
            static = 27017
          }
        }
      }
    }
  }
}
