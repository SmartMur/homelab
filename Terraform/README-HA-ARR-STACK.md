# Proxmox HA ARR Stack Deployment

Complete automation for deploying a highly available ARR stack (Sonarr, Radarr, Prowlarr, qBittorrent, etc.) on a 2-node Proxmox cluster with Pi4 as QDevice witness.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Proxmox HA Cluster                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Node 1 (alpha)              Node 2 (pve)                   │
│  192.168.100.100             192.168.100.200                │
│  ┌──────────────────┐        ┌──────────────────┐           │
│  │ arr-stack-1      │        │ arr-stack-2      │           │
│  │ Docker Compose   │        │ Docker Compose   │           │
│  │ Sonarr/Radarr    │        │ Sonarr/Radarr    │           │
│  │ Prowlarr/qBT     │        │ Prowlarr/qBT     │           │
│  └──────────────────┘        └──────────────────┘           │
│         │                            │                      │
│         └────────────┬───────────────┘                      │
│                      │                                      │
│              Shared Storage (PBS/CIFS)                      │
│              /srv/config, /srv/media                        │
│                                                              │
│  Corosync Cluster + QDevice                                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Pi4 (murzpi) - 192.168.13.83                         │  │
│  │ QDevice (qnetd) - Quorum Witness                     │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Prerequisites

### Infrastructure
- ✅ 2 Proxmox nodes in cluster (Agape)
- ✅ Pi4 with qnetd installed and running
- ✅ Shared storage (PBS, CIFS, NFS, or Ceph)
- ✅ Cloud-init template VM (ID: 9000)
- ✅ SSH key-based access to all hosts

### Software
- Terraform >= 1.0
- Proxmox Terraform Provider >= 3.0
- SSH client with key-based auth

### Proxmox API Token
Create an API token in Proxmox:
```bash
# SSH to Proxmox node
ssh root@192.168.100.100

# Create token (replace 'terraform' with desired user)
pveum user add terraform@pam
pveum acl modify / -user terraform@pam -role Administrator

# Create token
pveum user token add terraform@pam terraform
# Output: terraform@pam!terraform = <token-secret>
```

## Setup

### 1. Configure QDevice HA (if not already done)

```bash
# Run on one Proxmox node
cd /path/to/Terraform
chmod +x setup-qdevice-ha.sh
scp setup-qdevice-ha.sh root@192.168.100.100:/tmp/
ssh root@192.168.100.100 /tmp/setup-qdevice-ha.sh

# Verify
ssh root@192.168.100.100 pvecm status
ssh root@192.168.100.100 corosync-qdevice-net status
```

See `HA-SETUP-GUIDE.md` for detailed instructions.

### 2. Prepare Terraform

```bash
# Clone or navigate to Terraform directory
cd /Users/dre/Desktop/Smartmur/Terraform

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
nano terraform.tfvars
```

### 3. Configure terraform.tfvars

Key variables to set:

```hcl
# Proxmox API
proxmox_api_url      = "https://192.168.100.100:8006/api2/json"
proxmox_token_id     = "terraform@pam!terraform"
proxmox_token_secret = "your-token-secret"

# VM Configuration
vm_count     = 2
vm_cpu       = 4
vm_memory    = 4096
vm_disk_size = 50

# Network
vm_ip_type = "dhcp"  # or "static"

# SSH
vm_ssh_public_key = "ssh-rsa AAAA..."

# GitHub
github_repo_url = "https://github.com/sugarayhkins/homemedia.git"

# Storage
arr_storage_path = "/srv/media"
arr_config_path  = "/srv/config"

# HA
enable_ha = true
```

### 4. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan -out=tfplan

# Review plan output
# Apply configuration
terraform apply tfplan

# Monitor deployment
watch -n 5 'ssh root@192.168.100.100 pvecm status'
```

## Verification

### Check Cluster Status
```bash
ssh root@192.168.100.100 pvecm status
```

Expected output:
```
Quorum information
------------------
Expected votes:   3
Highest expected: 3
Total votes:      3
Quorum:           2
Flags:            Quorate
```

### Check QDevice
```bash
ssh root@192.168.100.100 corosync-qdevice-net status
```

### Check VMs
```bash
ssh root@192.168.100.100 qm list
```

### Check HA Resources
```bash
ssh root@192.168.100.100 ha-manager status
```

### Check ARR Stack
```bash
ssh root@192.168.100.100 qm exec 100 docker compose -f /opt/homemedia/docker-compose.yml ps
```

## Monitoring

### Watch Cluster Events
```bash
ssh root@192.168.100.100 journalctl -u corosync -f
```

### Monitor QDevice
```bash
ssh root@192.168.100.100 watch -n 2 'corosync-qdevice-net status'
```

### Check VM Logs
```bash
ssh root@192.168.100.100 qm exec 100 docker compose -f /opt/homemedia/docker-compose.yml logs -f
```

## Testing Failover

### Test 1: Node Failure
```bash
# Stop corosync on Node 1
ssh root@192.168.100.100 systemctl stop corosync

# Verify Node 2 still has quorum
ssh root@192.168.100.200 pvecm status

# Verify VMs restart on Node 2
ssh root@192.168.100.200 qm list

# Restart Node 1
ssh root@192.168.100.100 systemctl start corosync
```

### Test 2: VM Failover
```bash
# Get VM ID
VMID=$(ssh root@192.168.100.100 qm list | grep arr-stack-1 | awk '{print $1}')

# Stop VM
ssh root@192.168.100.100 qm stop $VMID

# Verify it restarts on other node
sleep 5
ssh root@192.168.100.200 qm list | grep arr-stack-1
```

## Troubleshooting

### QDevice Not Connecting
```bash
# Check qnetd on Pi4
ssh root@192.168.13.83 systemctl status corosync-qnetd

# Check connectivity
ssh root@192.168.100.100 nc -zv 192.168.13.83 5403

# Restart qdevice
ssh root@192.168.100.100 systemctl restart corosync-qdevice
```

### Quorum Lost
```bash
# Check cluster status
ssh root@192.168.100.100 pvecm status

# Check corosync logs
ssh root@192.168.100.100 journalctl -u corosync -n 50

# Check network connectivity
ssh root@192.168.100.100 ping -c 3 192.168.100.200
ssh root@192.168.100.100 ping -c 3 192.168.13.83
```

### Terraform Issues

**Provider authentication failed:**
```bash
# Verify API token
ssh root@192.168.100.100 pveum user token list

# Test API access
curl -k -H "Authorization: PVEAPIToken=terraform@pam!terraform=<secret>" \
  https://192.168.100.100:8006/api2/json/version
```

**Template VM not found:**
```bash
# List VMs
ssh root@192.168.100.100 qm list

# Verify template ID matches vm_template_id in terraform.tfvars
```

**Cloud-init not executing:**
```bash
# Check cloud-init logs on VM
ssh root@<vm-ip> cloud-init status
ssh root@<vm-ip> cat /var/log/cloud-init-output.log
```

## Customization

### Change VM Sizing
Edit `terraform.tfvars`:
```hcl
vm_cpu       = 8
vm_memory    = 8192
vm_disk_size = 100
```

### Use Static IPs
```hcl
vm_ip_type   = "static"
vm_ip_subnet = "192.168.1.0/24"
vm_ip_gateway = "192.168.1.1"
```

### Add More VMs
```hcl
vm_count = 3  # Creates arr-stack-1, arr-stack-2, arr-stack-3
```

### Disable HA
```hcl
enable_ha = false
```

### Use Different Repository
```hcl
github_repo_url    = "https://github.com/your-org/your-repo.git"
github_repo_branch = "develop"
arr_compose_path   = "docker/arr-stack/docker-compose.yml"
```

## Cleanup

### Destroy All Resources
```bash
terraform destroy
```

### Remove HA Configuration
```bash
ssh root@192.168.100.100 ha-manager remove vm:100
ssh root@192.168.100.100 ha-manager remove vm:101
```

### Remove QDevice
```bash
# Edit corosync.conf on both nodes
ssh root@192.168.100.100 nano /etc/corosync/corosync.conf
# Remove qdevice section

# Reload
ssh root@192.168.100.100 corosync-cfgtool -R
```

## Files

- `providers.tf` - Proxmox provider configuration
- `variables.tf` - Variable definitions
- `terraform.tfvars.example` - Example variables (copy to terraform.tfvars)
- `main.tf` - VM and HA resource definitions
- `templates/user-data.yaml` - Cloud-init user data
- `templates/network-config.yaml` - Cloud-init network config
- `setup-qdevice-ha.sh` - QDevice setup script
- `HA-SETUP-GUIDE.md` - Detailed HA setup guide

## References

- [Proxmox HA Documentation](https://pve.proxmox.com/wiki/High_Availability)
- [Corosync QDevice](https://corosync.github.io/corosync/qdevice/)
- [Terraform Proxmox Provider](https://registry.terraform.io/providers/telmate/proxmox/latest/docs)
- [Cloud-init Documentation](https://cloud-init.io/)

## Support

For issues:
1. Check logs: `journalctl -u corosync`, `journalctl -u corosync-qdevice`
2. Verify connectivity: `ping`, `nc`, `ssh`
3. Review Terraform state: `terraform state show`
4. Check Proxmox UI: https://192.168.100.100:8006

## License

Same as parent project
