# Proxmox HA ARR Stack - Deployment Checklist

## Pre-Deployment

- [x] SSH keys configured on macBook
- [x] SSH access verified to:
  - [x] Proxmox Node 1 (192.168.100.100)
  - [x] Proxmox Node 2 (192.168.100.200)
  - [x] Pi4 (192.168.13.83)
- [x] Cluster status verified (2 nodes, Agape cluster)
- [x] Shared storage verified (PBS, local-lvm, unifiDrive)
- [x] Pi4 qnetd installed and running

## Phase 1: QDevice HA Setup

- [ ] Run setup-qdevice-ha.sh on Node 1
  ```bash
  scp /Users/dre/Desktop/Smartmur/Terraform/setup-qdevice-ha.sh root@192.168.100.100:/tmp/
  ssh root@192.168.100.100 /tmp/setup-qdevice-ha.sh
  ```

- [ ] Verify QDevice on Node 1
  ```bash
  ssh root@192.168.100.100 corosync-qdevice-net status
  ```

- [ ] Run setup-qdevice-ha.sh on Node 2
  ```bash
  scp /Users/dre/Desktop/Smartmur/Terraform/setup-qdevice-ha.sh root@192.168.100.200:/tmp/
  ssh root@192.168.100.200 /tmp/setup-qdevice-ha.sh
  ```

- [ ] Verify QDevice on Node 2
  ```bash
  ssh root@192.168.100.200 corosync-qdevice-net status
  ```

- [ ] Verify cluster quorum (should show 3 votes)
  ```bash
  ssh root@192.168.100.100 pvecm status
  ```

- [ ] Verify HA status
  ```bash
  ssh root@192.168.100.100 ha-manager status
  ```

## Phase 2: Terraform Configuration

- [ ] Navigate to Terraform directory
  ```bash
  cd /Users/dre/Desktop/Smartmur/Terraform
  ```

- [ ] Copy example variables
  ```bash
  cp terraform.tfvars.example terraform.tfvars
  ```

- [ ] Edit terraform.tfvars with your values
  ```bash
  nano terraform.tfvars
  ```
  
  Required values to set:
  - [ ] `proxmox_api_url` - Your Proxmox API endpoint
  - [ ] `proxmox_token_id` - API token ID
  - [ ] `proxmox_token_secret` - API token secret
  - [ ] `vm_ssh_public_key` - Your SSH public key
  - [ ] `github_repo_url` - Your homemedia repo URL
  - [ ] `arr_storage_path` - Storage path for media
  - [ ] `arr_config_path` - Storage path for configs

- [ ] Verify terraform.tfvars is not committed to git
  ```bash
  grep terraform.tfvars .gitignore
  ```

## Phase 3: Terraform Deployment

- [ ] Initialize Terraform
  ```bash
  terraform init
  ```

- [ ] Validate configuration
  ```bash
  terraform validate
  ```

- [ ] Plan deployment
  ```bash
  terraform plan -out=tfplan
  ```

- [ ] Review plan output
  - [ ] Verify 2 VMs will be created (arr-stack-1, arr-stack-2)
  - [ ] Verify VMs will be distributed across nodes
  - [ ] Verify HA resources will be created
  - [ ] Verify correct storage and network settings

- [ ] Apply configuration
  ```bash
  terraform apply tfplan
  ```

- [ ] Monitor deployment
  ```bash
  watch -n 5 'ssh root@192.168.100.100 qm list'
  ```

## Phase 4: Post-Deployment Verification

- [ ] Verify VMs created
  ```bash
  ssh root@192.168.100.100 qm list | grep arr-stack
  ```

- [ ] Verify VM distribution
  - [ ] arr-stack-1 on Node 1 (alpha)
  - [ ] arr-stack-2 on Node 2 (pve)

- [ ] Verify HA resources
  ```bash
  ssh root@192.168.100.100 ha-manager status
  ```

- [ ] Wait for cloud-init to complete (5-10 minutes)
  ```bash
  ssh root@192.168.100.100 qm exec 100 cloud-init status --wait
  ```

- [ ] Verify Docker installed
  ```bash
  ssh root@192.168.100.100 qm exec 100 docker --version
  ```

- [ ] Verify Docker Compose installed
  ```bash
  ssh root@192.168.100.100 qm exec 100 docker compose version
  ```

- [ ] Verify repository cloned
  ```bash
  ssh root@192.168.100.100 qm exec 100 ls -la /opt/homemedia
  ```

- [ ] Verify ARR stack running
  ```bash
  ssh root@192.168.100.100 qm exec 100 docker compose -f /opt/homemedia/docker-compose.yml ps
  ```

- [ ] Verify storage paths created
  ```bash
  ssh root@192.168.100.100 qm exec 100 ls -la /srv/
  ```

## Phase 5: Failover Testing

- [ ] Test 1: Stop corosync on Node 1
  ```bash
  ssh root@192.168.100.100 systemctl stop corosync
  ```

- [ ] Verify Node 2 still has quorum
  ```bash
  ssh root@192.168.100.200 pvecm status
  ```

- [ ] Verify VMs still accessible
  ```bash
  ssh root@192.168.100.200 qm list | grep arr-stack
  ```

- [ ] Restart corosync on Node 1
  ```bash
  ssh root@192.168.100.100 systemctl start corosync
  ```

- [ ] Verify cluster reformed
  ```bash
  ssh root@192.168.100.100 pvecm status
  ```

- [ ] Test 2: Stop VM on Node 1
  ```bash
  VMID=$(ssh root@192.168.100.100 qm list | grep arr-stack-1 | awk '{print $1}')
  ssh root@192.168.100.100 qm stop $VMID
  ```

- [ ] Verify VM restarts on Node 2
  ```bash
  sleep 10
  ssh root@192.168.100.200 qm list | grep arr-stack-1
  ```

## Phase 6: Monitoring Setup (Optional)

- [ ] Setup Prometheus monitoring
  - [ ] Deploy Prometheus on one of the VMs or separate host
  - [ ] Configure node exporters on Proxmox nodes
  - [ ] Configure Corosync exporter

- [ ] Setup Grafana dashboards
  - [ ] Create cluster health dashboard
  - [ ] Create QDevice status dashboard
  - [ ] Create VM resource dashboard

- [ ] Setup alerting
  - [ ] Alert on quorum loss
  - [ ] Alert on QDevice disconnection
  - [ ] Alert on node failure

## Phase 7: Backup Configuration (Optional)

- [ ] Configure Proxmox Backup Server
  - [ ] Setup PBS on separate host or NAS
  - [ ] Configure backup schedule for VMs
  - [ ] Test restore procedure

- [ ] Configure VM-level backups
  - [ ] Setup restic or similar for /srv/config
  - [ ] Setup restic for /srv/media (if needed)

## Phase 8: Documentation

- [ ] Document your setup
  - [ ] Record VM IPs and hostnames
  - [ ] Document storage paths and mounts
  - [ ] Document backup procedures
  - [ ] Document failover procedures

- [ ] Create runbooks
  - [ ] Node failure recovery
  - [ ] QDevice failure recovery
  - [ ] Storage failure recovery
  - [ ] Complete cluster rebuild

## Troubleshooting Checklist

If deployment fails:

- [ ] Check Terraform logs
  ```bash
  TF_LOG=DEBUG terraform apply
  ```

- [ ] Verify Proxmox API access
  ```bash
  curl -k -H "Authorization: PVEAPIToken=..." https://192.168.100.100:8006/api2/json/version
  ```

- [ ] Check cloud-init logs on VM
  ```bash
  ssh root@192.168.100.100 qm exec 100 cat /var/log/cloud-init-output.log
  ```

- [ ] Check corosync logs
  ```bash
  ssh root@192.168.100.100 journalctl -u corosync -n 50
  ```

- [ ] Check QDevice logs
  ```bash
  ssh root@192.168.100.100 journalctl -u corosync-qdevice -n 50
  ```

- [ ] Verify network connectivity
  ```bash
  ssh root@192.168.100.100 ping -c 3 192.168.100.200
  ssh root@192.168.100.100 ping -c 3 192.168.13.83
  ```

## Completion

- [ ] All phases completed successfully
- [ ] All tests passed
- [ ] Documentation updated
- [ ] Team notified of new infrastructure
- [ ] Monitoring and alerting active
- [ ] Backup procedures tested

## Notes

Use this space to document any issues encountered or customizations made:

```
[Add notes here]
```

## Sign-Off

- Deployment Date: _______________
- Deployed By: _______________
- Verified By: _______________
- Notes: _______________
