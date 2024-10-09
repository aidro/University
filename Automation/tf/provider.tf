terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
 pm_api_url          = proxmox_url
 pm_api_token_id     = pm_api_token_id
 pm_api_token_secret = pm_api_token_secret
 pm_tls_insecure     = true
}