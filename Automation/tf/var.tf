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

variable "pm_api_token_id" {
    type = string
    default = "root@pam!main"
    nullable = false
}

variable "pm_api_token_secret" {
    type = string
    default = "35b3fa77-3345-4ef4-9cc0-59a3e39c5c18"
    nullable = false
}

### Global variables
variable "password" {
    type = string
    default = ""
}

variable "node" {
    type = string
    default = "srv01"
}

variable "iso" {
    type = string
    default = "cephfs:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
    nullable = false
}

variable "hostname" {
    type = string
    default = "test"
}

variable "ip_address" {
    type = string
    default = "10.24.49.200"
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
    default = "test"
    nullable = false
}


### LXC variables
variable "ct_name" {
    type = string
    default = "test" 
}