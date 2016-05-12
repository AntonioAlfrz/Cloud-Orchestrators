# Identificación
region="Europe"
datacenter="Azure"
name="Client-X"
# Configuración
bind_addr=""
# Directorio
data_dir = "/tmp/nomad"
leave_on_interrupt = true
leave_on_terminate = true
# Enable the client
client {
  enabled = true
	servers = ["nomad.service.consul:4647"]
  node_class = "Public"
}
