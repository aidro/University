### Provider variables
variable "proxmox_url" {
    type = string
    default = "http://10.24.49.10:8006/api2/json"
    nullable = false
}

variable "proxmox_user" {
    type = string
    default = "root@pam!main"
    nullable = false
}

variable "proxmox_password" {
    type = string
    default = "Buddier131!"
}

### Global variables
variable "password" {
    type = string
    default = ""
}

variable "target_node" {
    type = string
    default = "aidro-cluster"
}

variable "iso" {
    type = string
    default = ""
    nullable = false
}

variable "hostname" {
    type = string
    default = ""
}

variable "ip_address" {
    type = string
    default = ""
}

variable "cores" {
    type = number
    default = 1
    nullable = false
}

variable "sockets" {
    type = number
    default = 1
    nullable = false
}

variable "memory" {
    type = number
    default = 1024
    nullable = false
}

variable "disk_storage" {
    type = string
    default = "local-lvm"
    nullable = false
}

variable "disk_size" {
    type = string
    default = "16G"
    nullable = false
}

variable "network_model" {
    type = string
    default = "virtio"
    nullable = false
}

variable "network_bridge" {
    type = string
    default = "vmbr0"
    nullable = false
}

### VM variables
variable "vm_name" {
    type = string
    default = "youritguyvm"
    nullable = false
}

variable "qemu_os" {
    type = string
    default = "l26"
    nullable = false
}


### LXC variables
variable "ct_name" {
    type = string
    default = "" 
}

variable "ct_bridge" {
  type = string
}

variable "ct_datastore_storage_location" {
  type = string
}

variable "ct_datastore_template_location" {
  type = string
}

variable "ct_nic_rate_limit" {
  type = number
}

variable "ct_memory" {
  type = number
}

variable "ct_source_file_path" {
  type = string
}

variable "dns_domain" {
  type = string
}

variable "dns_server" {
  type = string
}

variable "gateway" {
  type = string
}

variable "os_type" {
  type = string
}

variable "tmp_dir" {
  type = string
}
