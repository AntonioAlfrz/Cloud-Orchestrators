# Identificación de la máquina
region="Europe"
datacenter="Azure"
name="Server-X"
# Configuración
bind_addr = ""
data_dir = "/tmp/nomad"
# Servidor
leave_on_interrupt = true
leave_on_terminate = true
server {
    enabled = true
    rejoin_after_leave = true
    bootstrap_expect = 2

}
