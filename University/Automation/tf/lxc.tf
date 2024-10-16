resource "proxmox_lxc" "basic" {
  target_node  = var.node
  hostname     = var.hostname
  ostemplate   = var.iso
  password     = var.password
  unprivileged = true
  start        = true
  cores        = "2"
  memory       = "8192"
  ssh_public_keys = file("~/.ssh/id_rsa.pub")

  rootfs {
    storage = var.disk_storage
    size    = var.disk_size
  }

  network {
    name   = "eth0"
    bridge = var.network_bridge
    ip     = "10.24.49.200/24"
    gw     = "10.24.49.1"
  }

  timeouts {
    create = "2m"
  }

  # Use provisioners to install Docker and configure services
  provisioner "file" {
    source      = "/scripts/script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("~/.ssh/id_rsa")
      host     = "10.24.49.200"
    }

   inline = [
      "chmod +x /tmp/script.sh",
      "./script.sh",
    ]
  }
}