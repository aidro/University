terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
 pm_api_url          = "http://10.24.49.10:8006/api2/json"
 pm_api_token_id     = "root@pam!main"
 pm_api_token_secret = "35b3fa77-3345-4ef4-9cc0-59a3e39c5c18"
 pm_tls_insecure     = true
}