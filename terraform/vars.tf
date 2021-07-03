#asumimos que todas las máquinas virtuales para Worker y NFS tienen el mismo tamaño
variable "vm_size" {
  type = string
  description = "Tamaño de la máquina virtual para workers y NFS"
  default = "Standard_A1_v2" # 2 GB ram, 1 CPU, 10 GB Temporary Disk (SSD) 
}

#tamaño para la máquina virtual Master
variable "vm_size_master" {
  type = string
  description = "Tamaño de la máquina virtual para Master"
  default = "Standard_A2_v2" # 4 GB ram, 2 CPU, 20 GB Temporary Disk (SSD) 
}

#Variable para la máquina virtual Master/NFS
variable "vms_master" {
  description = "máquinas virtuales a crear"
  type = string
  default = "master"
}

#Variable para Máquinas virtuales nodos
variable "vms" {
  description = "máquinas virtuales a crear"
  type = list(string)
  default = ["worker01", "worker02"]
}
