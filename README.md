# uni-cloud
Repository for Uni assignments

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
    1. ***Saltstack configuratie:***
        1. Installeren Proxmox:
            1. Basis installatie doorlopen
            2. Fix apt-mirrors
            3. VM toevoegen aan bestaande cluster
            4. Snapshot schedule maken in Proxmox
            5. Iets met een firewall
        2. Aanmaken gebruikers:
            1. 2 losse gebruikers:
                1. Genereer ssh keypair
            2. Gebruikers voor docker-compose, saltstack, wordpress-server, netdata en watchtower 
        3. Installeren docker-compose
        4. Opzetten docker-networking
        5. Docker-compose:
            1. Installeren Saltstack
            2. Installeren Wordpress server
                1. 30gb disk, 1 proc, 1 gb mem, 50mbit max.
            3. Installeren Netdata
            4. Installeren EspoCRM
                1. Failover opzetten
            5. Installeren Watchtower
