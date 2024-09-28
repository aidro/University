resource "proxmox_lxc" "basic" {
  target_node  = "pve"
  hostname     = "ct110"
  ostemplate   = "cephfs:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  password     = "Welkom1!"
  unprivileged = true

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.24.49.20/24"
  }
}