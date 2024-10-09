import argparse

class Parser:
    def Parse(self):
        # Initialize the parser to create all the necessary arguments for custom LXC creation
        parser = argparse.ArgumentParser(description='Create a new CT or VM in Proxmox')

        # Add the arguments to the parser
        parser.add_argument('-pu','--proxmox_url', metavar='proxmox_url', type=str, help='The URL of the Proxmox server')
        parser.add_argument('-pp','--proxmox_password', metavar='proxmox_password', type=str, help='The password of the Proxmox user')#, required=True)
        parser.add_argument('-pus','--proxmox_user', metavar='proxmox_user', type=str, help='The user of the Proxmox server')
        parser.add_argument('-vn','--vm_name', metavar='vm_name', type=str, help='The name of the VM')
        parser.add_argument('-nn', '--node_name', metavar='node_name', type=str, help='The name of the node to create the VM on')
        parser.add_argument('-qos', '--qemu_os', metavar='qemu_os', type=int, help='The Qemu OS of the VM')
        parser.add_argument('-ot', '--os_type', metavar='os_type', type=str, help='The OS type of the VM')
        parser.add_argument('-iso', '--iso', metavar='iso', type=str, help='The ISO to use for the VM')
        parser.add_argument('-c', '--cores', metavar='cores', type=int, help='The number of cores to use for the VM')
        parser.add_argument('-s', '--sockets', metavar='sockets', type=int, help='The number of sockets to use for the VM')
        parser.add_argument('-m', '--memory', metavar='memory', type=int, help='The memory to use for the VM')
        parser.add_argument('-dc', '--disk_container', metavar='disk_container', type=int, help='The disk size to use for the VM')
        parser.add_argument('-dt', '--disk_type', metavar='disk_type', type=int, help='The disk type [ IDE, SATA...] size to use for the VM')
        parser.add_argument('-ds', '--disk_size', metavar='disk_size', type=int, help='The disk size to use for the VM')
        parser.add_argument('-nm', '--net_model', metavar='net_model', type=int, help='The network card model to use for the VM')
        parser.add_argument('-nb', metavar='net_bridge', type=int, help='The network bridge to use for the VM')

        parser.add_argument('-ct_name', metavar='net_bridge', type=int)
        parser.add_argument('-ct_bridge', metavar='net_bridge', type=int)
        parser.add_argument('-target_node', metavar='net_bridge', type=int)
        parser.add_argument('-ct_datastore_template_location', metavar='net_bridge', type=int)
        parser.add_argument('-iso', metavar='net_bridge', type=int)
        parser.add_argument('-cores', metavar='net_bridge', type=int)
        parser.add_argument('-ct_memory', metavar='net_bridge', type=int)
        parser.add_argument('-sockets', metavar='net_bridge', type=int)
        parser.add_argument('-dns_domain', metavar='net_bridge', type=int)
        parser.add_argument('-disk_storage', metavar='net_bridge', type=int)
        parser.add_argument('-disk_size', metavar='net_bridge', type=int)
        parser.add_argument('-network_bridge', metavar='net_bridge', type=int)
        parser.add_argument('-ip_address', metavar='net_bridge', type=int)
        # Parse the arguments
        self.args = parser.parse_args()

        return self.args