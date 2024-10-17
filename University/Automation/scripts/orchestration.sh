#!/bin/bash

function fixapt(){
    # Change necessary apt-mirrors for Proxmox
    echo -e "\ndeb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" >> /etc/apt/sources.list
    echo -e "\ndeb deb http://download.proxmox.com/debian/ceph-reef bookworm no-subscription" >> /etc/apt/sources.list.d/ceph.list
    echo -e "\ndeb http://download.proxmox.com/debian/pve bookworm no-subscription" >> /etc/apt/sources.list.d/pve-enterprise.list
    
    # Applying changes and upgrading to latest software
    sudo apt update -y && sudo apt upgrade -y
}

function terraform(){
    # Downloading GPG keys and adding them to the apt-keyrings list so we can use Terraforms appropriate apt-mirror
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    
    # Applying changes and upgrading to latest software
    sudo apt update -y && sudo apt upgrade -y

    # Installing Terraform
    sudo apt install terraform

    # Creating necessary directories for later use
    mkdir /opt/terraform && mkdir /opt/terraform/tf
}

function pvecluster(){
    # Grabbing IP-Address of host
    localip=$(ip addr show vmbr0 | grep -oP "(?<=inet\s)\d+(\.\d+){3}")

    # Create a name for the cluster
    read -p  "Please insert clustername: " cluster_name

    # Creating the cluster
    pvecm create $cluster_name

    # Using SSH to remotely configure each target machine to join the cluster
    read -p "Please enter the IP-Addresses of the hosts you want to add to the cluster: [I.E: 10.0.0.0, 10.0.0.1, 10.0.0.2] " cluster_nodes

    for ip in $(echo $cluster_nodes | sed "s/,/ /g")
    do
        ssh -t root@$ip "pvecm add $localip"
    done
}

function cephcluster(){
    # Grabbing IP-Address of host
    localip=$(ip addr show vmbr0 | grep -oP "(?<=inet\s)\d+(\.\d+){3}")

    # Creating the cluster
    pveceph install --repository no-subscription --version reef && pveceph init --network $localip/24

    # Using SSH to remotely configure each target machine to join the cluster
    read -p "Please enter the IP-Addresses of the hosts you want to add to the cluster: [I.E: 10.0.0.0, 10.0.0.1, 10.0.0.2] " cluster_nodes

    for ip in $(echo $cluster_nodes | sed "s/,/ /g");
    do
        ssh -t root@$ip "pveceph init --network "10.24.49.0"/24 && pveceph osd create /dev/sda4 && pveceph mon create && pveceph mgr create" 
    done

    # Creating a pool named "cephfs"
    pveceph pool create cephfs
    pveceph mds create

    # Creating a CephFS fileshare
    pveceph fs create --pg_num 128 --add-storage
}

function createlxc(){
    # Show available images
    gw=10.24.49.1
    images=$(pveam available --section system)
    count=0
    
    # Format images in list for user to choose from
    for image in $images;
    do
        if echo $image | grep -q "system"; then
            continue
        fi
        count=$((count + 1))
        echo ""$count". "$image""
    done

    read -p "What image would you like to download? [COPY NAME OF IMAGE NOT #]" install_image

    # Downloading chosen image
    pveam download cephfs $install_image

    read -p "How many containers would you like to create? " lxc_num

    # Format images in list for user to choose from
    echo -e "What image would you like to install on the clients?"
    sleep 2

    count=0
    for image in $(pveam list cephfs | grep -oP "(?<=cephfs:)[^\s]+");
    do
        count=$((count + 1))
        echo ""$count". "$image""
        varname="image$(($count))"
        eval "$varname=${image}"
    done

    read -p "Please insert image number to be installed: " image_number
    chosen_image="image$(($image_number))"
    
    initial_id=100
    ip="10.24.49.200"
    pct create $initial_id cephfs:${!chosen_image} \
        --rootfs local-lvm:8 \
        --net0 name=eth0,bridge=vmbr0,ip=$ip/24,gw=$gw \
        --cores 1 \
        --memory 512 \
        --password Welkom1! \
        --start 1 \
        --ssh-public-keys /root/.ssh/id_rsa.pub \
        --nameserver '8.8.8.8' \

    # To run docker inside unprivileged LXC containers
    echo -e "overlay\naufs" >> /etc/modules-load.d/modules.conf
    lsmod | grep -E 'overlay|aufs'
    echo -e features: keyctl=1,nesting=1 >> /etc/pve/lxc/$initial_id.conf
    pct reboot $initial_id

    # Clone Git repository and run essential files
    git clone https://github.com/aidro/University.git
    cd University
    git checkout cloud
    cd "$(pwd)""/University/Automation"

    # Copy Wordpress Docker installation files to container
    scp -r -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    scripts/install.sh \
    scripts/wp/ \
    scripts/nginx-conf/ \
    root@$ip:/home

    # Install Wordpress via Docker on container
    pct exec $initial_id -- bash -c "source /home/install.sh && cd /home/wp && install_docker"

    # Create a template and clone ten times
    pct stop $initial_id
    pct template $initial_id

    for i in $(seq 1 $lxc_num);
    do
        id="10${i}"
        ip="10.24.49.20${i}"
        pct clone $initial_id $id
        pct set $initial_id \
        --hostname $id \
        --net0 name=etho0,bridge=vmbr0,ip=$ip/24,gw=$gw
        
    done
}