resource "proxmox_lxc" "basic" {
  target_node  = var.node
  hostname     = var.hostname
  ostemplate   = var.iso
  password     = var.password
  unprivileged = true
  start        = true
  cores        = "2"
  memory       = "8192"
  nameserver   = "8.8.8.8"
  ssh_public_keys = file("~/.ssh/id_rsa.pub")

  rootfs {
    storage = var.disk_storage
    size    = var.disk_size
  }

  network {
    name   = "eth0"
    bridge = var.network_bridge
    ip     = "10.24.49.201/24"
    gw     = "10.24.49.1"
  }

  timeouts {
    create = "2m"
  }

  clone {
    vmid        = "101"                # The vm_id of the LXC template to clone
    full_clone  = true                 # Create a full clone (true) or a linked clone (false)
  }
}