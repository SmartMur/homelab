# ✅ Proxmox HA ARR Stack - Setup Complete

## Connectivity Status

All hosts are reachable and accessible from your macBook:

| Host | IP | Status | Latency | Kernel |
|------|----|---------|---------|----|
| Proxmox Node 1 (alpha) | 192.168.100.100 | ✅ OK | 4.2ms | 6.17.4-2-pve |
| Proxmox Node 2 (pve) | 192.168.100.200 | ✅ OK | 4.3ms | 6.17.9-1-pve |
| Pi4 (murzpi) | 192.168.13.83 | ✅ OK | 1.1ms | 6.12.62+rpt-rpi-v8 |

## Infrastructure Ready

✅ SSH keys configured on all hosts
✅ Passwordless SSH access verified
✅ Network connectivity verified
✅ Cluster status verified (2 nodes)
✅ Shared storage verified (PBS, local-lvm, unifiDrive)
✅ Pi4 qnetd installed and running

## Files Created

### Terraform Configuration
- `providers.tf` - Proxmox provider setup
- `variables.tf` - Variable definitions
- `terraform.tfvars.example` - Example configuration
- `main.tf` - VM and HA resource definitions

### Cloud-Init Templates
- `templates/user-data.yaml` - VM initialization script
- `templates/network-config.yaml` - Network configuration

### Setup & Verification Scripts
- `setup-qdevice-ha.sh` - QDevice HA setup script
- `verify-connectivity.sh` - Connectivity verification script

### Documentation
- `HA-SETUP-GUIDE.md` - Detailed QDevice HA setup
- `README-HA-ARR-STACK.md` - Complete deployment guide
- `QUICK-REFERENCE.md` - Quick commands
- `DEPLOYMENT-CHECKLIST.md` - Step-by-step checklist
- `DEPLOYMENT-SUMMARY.txt` - Setup summary

## Quick Start

### 1. Setup QDevice HA (if not done)
```bash
cd /Users/dre/Desktop/Smartmur/Terraform
chmod +x setup-qdevice-ha.sh

# Run on Node 1
scp setup-qdevice-ha.sh root@192.168.100.100:/tmp/
ssh root@192.168.100.100 /tmp/setup-qdevice-ha.sh

# Run on Node 2
scp setup-qdevice-ha.sh root@192.168.100.200:/tmp/
ssh root@192.168.100.200 /tmp/setup-qdevice-ha.sh

# Verify
ssh root@192.168.100.100 pvecm status
ssh root@192.168.100.100 corosync-qdevice-net status
```

### 2. Configure Terraform
```bash
cd /Users/dre/Desktop/Smartmur/Terraform
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

# Set these required values:
# - proxmox_api_url
# - proxmox_token_id
# - proxmox_token_secret
# - vm_ssh_public_key
# - github_repo_url
```

### 3. Deploy with Terraform
```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### 4. Verify Deployment
```bash
ssh root@192.168.100.100 qm list
ssh root@192.168.100.100 ha-manager status
ssh root@192.168.100.100 qm exec 100 docker compose -f /opt/homemedia/docker-compose.yml ps
```

## What Gets Deployed

### VMs
- **arr-stack-1** on Node 1 (alpha)
- **arr-stack-2** on Node 2 (pve)

### Per VM
- 4 CPU cores (configurable)
- 4GB RAM (configurable)
- 50GB disk (configurable)
- Docker + docker-compose plugin
- Your homemedia repository
- ARR stack (Sonarr, Radarr, Prowlarr, qBittorrent, etc.)

### HA Features
- Automatic failover on node failure
- 3-node quorum (2 Proxmox nodes + Pi4 witness)
- Shared storage for persistent data
- Health monitoring and recovery

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
│  │ ARR Stack        │        │ ARR Stack        │           │
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

## Next Steps

1. **Setup QDevice HA** (if not already done)
   - Run `setup-qdevice-ha.sh` on both Proxmox nodes
   - Verify with `pvecm status` and `corosync-qdevice-net status`

2. **Create Proxmox API Token**
   ```bash
   ssh root@192.168.100.100
   pveum user token add terraform@pam terraform
   # Save the token secret
   ```

3. **Configure terraform.tfvars**
   - Copy `terraform.tfvars.example` to `terraform.tfvars`
   - Fill in your API credentials and settings

4. **Deploy with Terraform**
   - Run `terraform init`
   - Run `terraform plan`
   - Run `terraform apply`

5. **Verify Deployment**
   - Check VMs created
   - Check HA resources
   - Check ARR stack running

6. **Test Failover** (optional)
   - Stop a node and verify failover
   - Stop a VM and verify restart

## Documentation

For detailed information, see:
- `HA-SETUP-GUIDE.md` - QDevice HA setup details
- `README-HA-ARR-STACK.md` - Full deployment guide with troubleshooting
- `QUICK-REFERENCE.md` - Common commands
- `DEPLOYMENT-CHECKLIST.md` - Step-by-step checklist

## Support

For issues:
1. Run `verify-connectivity.sh` to check connectivity
2. Check logs: `journalctl -u corosync`, `journalctl -u corosync-qdevice`
3. Review Terraform logs: `TF_LOG=DEBUG terraform apply`
4. Check cloud-init: `qm exec 100 cat /var/log/cloud-init-output.log`

## Summary

Your infrastructure is ready for deployment! You have:
- ✅ All hosts reachable and accessible
- ✅ SSH keys configured
- ✅ Terraform configuration files created
- ✅ Cloud-init templates ready
- ✅ Setup scripts prepared
- ✅ Comprehensive documentation

You can now proceed with QDevice HA setup and Terraform deployment.

---

**Last Updated**: 2026-02-14
**Status**: Ready for Deployment ✅
