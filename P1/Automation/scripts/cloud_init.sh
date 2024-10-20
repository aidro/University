#!/bin/bash

function cloud_init(){

    # Export environment variables for later use
    export CUSTOM_USER_NAME=ubuntu
    export CUSTOM_USER_PASSWORD=password

    wget -q https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
    
    # Resizing the image so that containers provision themselves with enough storage
    qemu-img resize noble-server-cloudimg-amd64.img 32G

    qm create 8010 \
    --name "ubuntu-2404-cloudinit-template" \
    --ostype l26 \
    --memory 1024 \
    --agent 1 \
    --bios ovmf --machine q35 --efidisk0 local-lvm:0,pre-enrolled-keys=0 \
    --cpu host --socket 1 --cores 1 \
    --vga serial0 --serial0 socket  \
    --net0 virtio,bridge=vmbr0

    lxc_num=1

    for i in $(seq 1 $lxc_num);
    doqm
        id="10${i}"
        ip="10.24.49.20${i}"
        pct create $id noble-server-cloudimg-amd64.img \
            --name "ubuntu-2404-cloudinit-template" \
            --ostype l26 \
            --rootfs local-lvm:8 \
            --net0 name=etho0,bridge=vmbr0,ip=$ip/24,gw=10.24.49.1 \
            --cores 1 \
            --memory 512 \
            --password Welkom1! \
            --start 1

        qm importdisk 8010 noble-server-cloudimg-amd64.img local-lvm

        qm set 8010 --scsihw virtio-scsi-pci --virtio0 local-lvm:vm-8010-disk-1,discard=on

        qm set 8010 --ide2 local-lvm:cloudinit

        # cat << EOF | tee /var/lib/vz/snippets/vendor.yaml
        # #cloud-config
        # runcmd:
        #     - apt update
        #     - apt install -y qemu-guest-agent
        #     - systemctl start qemu-guest-agent
        #     - reboot
        # EOF

        qm set 8010 --cicustom "vendor=local:snippets/vendor.yaml"
        qm set 8010 --tags ubuntu-template,24.04,cloudinit
        qm set 8010 --ciuser $CUSTOM_USER_NAME --ciupgrade 1
        qm set 8010 --cipassword $(openssl passwd -6 $CUSTOM_USER_PASSWORD)
        qm set 8010 --sshkeys ~/.ssh/authorized_keys
        qm set 8010 --ipconfig0 ip=dhcp

        qm cloudinit update 8010

        qm template 8010

        qm clone 8010 470 --name ubuntu-2404-test -full -storage local-lvm
        qm set 470 --ipconfig0 ip=10.0.5.78/24,gw=10.0.5.1
        qm resize 470 virtio0 +35G
        qm set 470 --core 4 --memory 5120 --balloon 0
        qm start 470
    done

   
}