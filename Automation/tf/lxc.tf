resource "proxmox_lxc" "advanced_features" {
  target_node  = var.node
  hostname     = var.hostname
  ostemplate   = var.iso
  password     = var.password
  unprivileged = true

  rootfs {
    storage = var.disk_storage
    size    = var.disk_size
  }

  network {
    name   = "eth0"
    bridge = var.network_bridge
    ip     = var.ip_address
  }

}
 