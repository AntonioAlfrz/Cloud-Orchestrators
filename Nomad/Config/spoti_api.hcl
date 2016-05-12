job "Spoti-api" {
	#region = "Europe"
	datacenters = ["Azure"]
	type = "service"
	update {
		stagger = "10s"
		max_parallel = 1
	}
  group "API"{
    count = 2
    restart {
			# The number of attempts to run the job within the specified interval.
			attempts = 3
			interval = "5m"
			# A delay between a task failing and a restart occurring.
			delay = "25s"
			mode = "delay"
		}
  	task "spoti-api" {
  		driver = "docker"
  		config {
  			image = "aalferez/nomad_api"
  			port_map {
  				http = 3000
  			}
  		}
      env{
        AZURE_STORAGE_ACCOUNT="cdps"
        AZURE_STORAGE_ACCESS_KEY="6VyhZ2Mqt1kgGjJEFlh7hqPd/v1AEDCX+9/tN1IoOsZsX4VmZC8C8dwoaCGPjwRl6bGSRNQiXpfnwCxK4IGhjg=="
      }
  		service {
				name = "apiservice"
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
