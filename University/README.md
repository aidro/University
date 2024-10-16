---

## Plan van aanpak

---

1. Subnet tabel maken

| **NAME** | **IP** | **MASK** |
| --- | --- | --- |
| Gateway | 10.24.49.1 | 255.255.255.0 |
| SRV01 | 10.24.49.10 | 255.255.255.0 |
| SRV02 | 10.24.49.11 | 255.255.255.0 |
| SRV03 | 10.24.49.12 | 255.255.255.0 |
1. Automatiseer doormiddel van Saltstack(API of YAML) Proxmox cluster configuratie:
2. Opdracht:
    1. **Proxmox**
        1. Basis installatie doorlopen
        2. Fixing [APT-mirrors]
        3. VM toevoegen aan bestaande cluster
        4. CephFS cluster opzetten
        5. HA Group aanmaken
        6. Snapshot schedule maken in Proxmox
    2. **Wordpress Servers**:
        1. [*Aanmaken LXC Containers]:*
            1. Beperken resources
            2. Toevoegen aan HA Group
            3. *Aanmaken gebruikers:*
                1. 2 losse gebruikers
                    1. Genereer SSH keypairs
                2. Gebruikers voor docker-compose, saltstack, wordpress server, netdata en watchtower 
            4. *Installeren docker-compose:*
                1. Installeren Saltstack
                2. Installeren Wordpress server
                    1. 30gb disk, 1 proc, 1 gb mem, 50mbit max.
                3. Installeren Netdata
                4. Installeren EspoCRM
                    1. Failover
                5. Installeren Watchtower
            5. *Opzetten iptables firewall:*
                1. Blokkeer incoming traffic
                2. Exceptions voor Saltstack, Wordpress, Netdata en CRM
    3. **Saltstack**

---

### APT-mirrors

Aanpassen apt repositories Proxmox:

```bash
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription
```

```bash
deb http://download.proxmox.com/debian/ceph-reef bookworm no-subscription
```

Toepassen van apt repository aanpassingen:

```bash
sudo apt update -y && apt upgrade -y
```

### Install SaltStack or Terraform

### Saltstack

Voeg de Saltstack apt repository toe:

```bash
curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/ubuntu/24.04/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/ubuntu/24.04/amd64/latest noble main" | tee /etc/apt/sources.list.d/salt.list
```

Toepassen van apt repository aanpassingen:

```bash
sudo apt update -y && apt upgrade -y
```

Installeer salt-master of salt-minion

```bash
sudo apt install [salt-master | salt-minion] -y
```

### Terraform

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update -y && sudo apt upgrade -y
sudo apt install terraform
```

### Setting up the cluster

On master node:

```bash
pvecm create <cluster_name>
```

On all other nodes that need to be added to the cluster:

```bash
pvecm add <cluster_ip_address>
```

### Setting up a CephFS HA fileshare

Starting with basic installation:

```bash
pveceph install && pveceph init --network <x.x.x.x/x>
```

Initialising network, adding OSD’s per ‘physical disk and creating monitors’:

```bash
ssh -t root@<ip_address> 'pveceph init --network 10.24.49.0/24 && pveceph osd create /dev/sda4 && pveceph mon create' 
```

Creating at least two managers for failover:

```bash
ssh -t root@<ip_address> 'pveceph mgr create' 
```

Creating a Ceph pool

```bash
pveceph pool create <pool-name>
```

At least one metadata server:

```bash
pveceph mds create
```

Creating actual CephFS storage pool

```bash
pveceph fs create --pg_num 128 --add-storage
```

### Aanmaken LXC-containers

Check available images:

```bash
pveam available
```

Download desired image and make available in storage pool:

```bash
pveam download cephfs ubuntu-24.04-standard_24.04-2_amd64.tar.zst
```

Show available images:

```bash
pveam list <storage-pool-name>
```

Creating the CT:

```bash
pct create 101 cephfs:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst --rootfs local-lvm:8 --hostname <hostname> --cores 1 --memory 512 --storage <storage ID> --password <password> --ssh-public-keys <filepath> --start 1
```

```bash
pct create 102 cephfs:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst --rootfs local-lvm:8 --net0 name=etho0,bridge=vmbr0,ip=10.24.49.26/24,gw=10.24.49.1 --cores 1 --memory 512 --password Welkom1! --start 1
```

```bash
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

resource "proxmox_lxc" "basic" {
  target_node  = "pve"
  hostname     = "ct110"
  ostemplate   = "cephfs:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  password     = "Welkom1!"
  unprivileged = true

  // Terraform will crash without rootfs defined
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
```
