# movido a correccion-vars
#variable "location" {
#  type = string
#  description = "Región de Azure donde crearemos la infraestructura"
#  default = "West Europe"
#}

#asumimos que todas las máquinas virtuales para Workers y NFS tienen el mismo tamaño
variable "vm_size" {
  type = string
  description = "Tamaño de la máquina virtual para workers y NFS"
  default = "Standard_A1_v2" # 2 GB ram, 1 CPU, 10 GB Temporary Disk (SSD) 
}

#Variable para Máquinas virtuales 
variable "vms" {
  description = "máquinas virtuales a crear"
  type = list(string)
  default = ["worker01","worker02","nfs"]
}

#tamaño para la máquina virtual Master
variable "vm_size_Master" {
  type = string
  description = "Tamaño de la máquina virtual para Master"
  default = "Standard_A2_v2" # 4 GB ram, 2 CPU, 20 GB Temporary Disk (SSD) 
}

#Variable para la máquina virtual Master 
variable "vms_Master" {
  description = "máquinas virtuales a crear"
  type = string
  default = "master"
}
