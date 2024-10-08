terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
 pm_api_url          = var.proxmox_url
 pm_api_token_id     = var.proxmox_apikey
 pm_api_token_secret = var.proxmox_apitoken
 pm_tls_insecure     = true
}