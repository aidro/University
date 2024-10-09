from arguments import Parser
from proxmox import Proxmox
from python_terraform import Terraform

ParserInstance = Parser()
args = ParserInstance.Parse()

# Load Promox objects
ProxmoxVM = Proxmox.VM
ProxmoxCT = Proxmox.CT

# Invoke Terraform class
tf = Terraform(working_dir='./tf')

tfInit = tf.init()

# If the init fails, exit the script
if tfInit != 0:
    print("Terraform init failed")
    exit(1)

# Iterate over the arguments passed to the script from CLI and set the values of the proxmox object
for i in vars(args):
    if getattr(args, i) is not None:
        setattr(ProxmoxVM, i, getattr(args, i))
        setattr(ProxmoxCT, i, getattr(args, i))
    else:
        setattr(ProxmoxVM, i, None)
        setattr(ProxmoxCT, i, None)

# Setting appropriate IP-Range
# Setting hostnames
# Get appropriate OS






# Apply Terraform
tfApply = tf.apply(
    skip_plan=True, 
    auto_approve=True,
    var={
        'proxmox_url': ProxmoxCT.proxmox_url,
        'proxmox_apikey': ProxmoxCT.proxmox_apikey,
        'proxmox_apitoken': ProxmoxCT.proxmox_apitoken,
        'vm_name': ProxmoxCT.ct_name,
        'target_node': ProxmoxCT.target_node,
        'iso': ProxmoxCT.iso,
        'cores': ProxmoxCT.cores,
        'sockets': ProxmoxCT.sockets,
        'memory': ProxmoxCT.memory,
        'disk_storage': ProxmoxCT.disk_storage,
        'disk_size': ProxmoxCT.disk_size,
        'network_bridge': ProxmoxCT.network_bridge,
        'ip': ProxmoxCT.ip_address
    }
)

# If the apply fails, exit the script
if tfApply[0] != 0:
    print("Terraform apply failed")
    exit(1)
else:
    print("Terraform apply successful. VM created {}.".format(ProxmoxCT.vm_name)) 


