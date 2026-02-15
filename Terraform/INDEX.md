# 📋 Proxmox HA ARR Stack - Complete Setup Index

## ✅ Status: Ready for Deployment

All infrastructure is configured and verified. You can now proceed with QDevice HA setup and Terraform deployment.

---

## 🚀 Quick Start (3 Steps)

### Step 1: Setup QDevice HA
```bash
cd /Users/dre/Desktop/Smartmur/Terraform
chmod +x setup-qdevice-ha.sh
scp setup-qdevice-ha.sh root@192.168.100.100:/tmp/
ssh root@192.168.100.100 /tmp/setup-qdevice-ha.sh
```

### Step 2: Configure Terraform
```bash
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
# Fill in: proxmox_api_url, proxmox_token_id, proxmox_token_secret, vm_ssh_public_key
```

### Step 3: Deploy
```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

---

## 📁 File Organization

### 🔧 Terraform Configuration (4 files)
| File | Purpose | Size |
|------|---------|------|
| `providers.tf` | Proxmox provider setup | 366B |
| `variables.tf` | Variable definitions | 3.9K |
| `terraform.tfvars.example` | Example configuration | 2.0K |
| `main.tf` | VM and HA resources | 3.3K |

**Action**: Copy `terraform.tfvars.example` to `terraform.tfvars` and customize

### ☁️ Cloud-Init Templates (2 files)
| File | Purpose | Size |
|------|---------|------|
| `templates/user-data.yaml` | VM initialization | 4.2K |
| `templates/network-config.yaml` | Network config | 275B |

**Action**: No changes needed - used by Terraform

### 🛠️ Setup & Verification Scripts (2 files)
| File | Purpose | Size | Run On |
|------|---------|------|--------|
| `setup-qdevice-ha.sh` | QDevice HA setup | 2.9K | Proxmox nodes |
| `verify-connectivity.sh` | Connectivity check | 3.7K | macBook |

**Action**: Run `verify-connectivity.sh` first, then `setup-qdevice-ha.sh` on both nodes

### 📚 Documentation (7 files)

#### Getting Started
| File | Purpose | Size | Read First? |
|------|---------|------|-------------|
| `SETUP-COMPLETE.md` | Setup status & quick start | 7.1K | ✅ YES |
| `QUICK-REFERENCE.md` | Common commands | 3.5K | ✅ YES |

#### Detailed Guides
| File | Purpose | Size | When to Read |
|------|---------|------|--------------|
| `HA-SETUP-GUIDE.md` | QDevice HA setup details | 4.9K | Before running setup script |
| `README-HA-ARR-STACK.md` | Complete deployment guide | 9.5K | Before Terraform deployment |
| `DEPLOYMENT-CHECKLIST.md` | Step-by-step checklist | 6.7K | During deployment |

#### Reference
| File | Purpose | Size | When to Read |
|------|---------|------|--------------|
| `FILES-CREATED.md` | File descriptions | 7.4K | For file reference |
| `INDEX.md` | This file | - | Navigation |

---

## 📊 Infrastructure Overview

```
Your Proxmox Cluster (Agape)
├── Node 1: alpha (192.168.100.100)
├── Node 2: pve (192.168.100.200)
└── Witness: Pi4 murzpi (192.168.13.83)

Deployment
├── VM 1: arr-stack-1 (on alpha)
├── VM 2: arr-stack-2 (on pve)
└── Shared Storage: PBS, local-lvm, unifiDrive

Features
├── HA: Automatic failover
├── Quorum: 3-node (2 nodes + Pi4 witness)
├── Docker: Pre-installed
└── ARR Stack: Sonarr, Radarr, Prowlarr, qBittorrent
```

---

## 🎯 Deployment Phases

### Phase 1: QDevice HA Setup
**Files**: `setup-qdevice-ha.sh`, `HA-SETUP-GUIDE.md`
**Duration**: 10-15 minutes
**Steps**:
1. Run setup script on Node 1
2. Run setup script on Node 2
3. Verify with `pvecm status`

### Phase 2: Terraform Configuration
**Files**: `terraform.tfvars.example`, `variables.tf`
**Duration**: 5-10 minutes
**Steps**:
1. Copy example to terraform.tfvars
2. Fill in required values
3. Validate configuration

### Phase 3: Terraform Deployment
**Files**: `main.tf`, `providers.tf`, `templates/`
**Duration**: 15-20 minutes
**Steps**:
1. Run `terraform init`
2. Run `terraform plan`
3. Run `terraform apply`

### Phase 4: Verification
**Files**: `DEPLOYMENT-CHECKLIST.md`
**Duration**: 10-15 minutes
**Steps**:
1. Check VMs created
2. Check HA resources
3. Check ARR stack running

### Phase 5: Testing (Optional)
**Files**: `DEPLOYMENT-CHECKLIST.md`
**Duration**: 15-20 minutes
**Steps**:
1. Test node failure
2. Test VM failover
3. Verify recovery

---

## 📖 Reading Guide

### For First-Time Setup
1. Start with: `SETUP-COMPLETE.md`
2. Then read: `QUICK-REFERENCE.md`
3. Before QDevice: `HA-SETUP-GUIDE.md`
4. Before Terraform: `README-HA-ARR-STACK.md`
5. During deployment: `DEPLOYMENT-CHECKLIST.md`

### For Troubleshooting
1. Check: `QUICK-REFERENCE.md` (Troubleshooting section)
2. Then: `README-HA-ARR-STACK.md` (Troubleshooting section)
3. Then: `HA-SETUP-GUIDE.md` (Troubleshooting section)

### For Reference
1. Commands: `QUICK-REFERENCE.md`
2. Files: `FILES-CREATED.md`
3. Architecture: `README-HA-ARR-STACK.md`

---

## ✅ Pre-Deployment Checklist

- [x] SSH keys configured on all hosts
- [x] Connectivity verified (all hosts reachable)
- [x] Cluster verified (2 nodes, Agape)
- [x] Shared storage verified
- [x] Pi4 qnetd installed and running
- [x] Terraform files created
- [x] Cloud-init templates created
- [x] Documentation complete

**Next**: Run `setup-qdevice-ha.sh` on both Proxmox nodes

---

## 🔑 Important Files to Customize

### 1. `terraform.tfvars` (Create from example)
```bash
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```

**Required values**:
- `proxmox_api_url` - Your Proxmox API endpoint
- `proxmox_token_id` - API token ID
- `proxmox_token_secret` - API token secret
- `vm_ssh_public_key` - Your SSH public key

### 2. `setup-qdevice-ha.sh` (No changes needed)
Just run it on both nodes

### 3. Cloud-init templates (No changes needed)
Automatically used by Terraform

---

## 🚨 Critical Notes

1. **API Token**: Create in Proxmox before Terraform
   ```bash
   ssh root@192.168.100.100
   pveum user token add terraform@pam terraform
   ```

2. **terraform.tfvars**: Keep secure, don't commit to git
   ```bash
   echo "terraform.tfvars" >> .gitignore
   ```

3. **Cloud-init Template**: Must exist with ID 9000
   ```bash
   ssh root@192.168.100.100 qm list | grep 9000
   ```

4. **Shared Storage**: Must be accessible from both nodes
   ```bash
   ssh root@192.168.100.100 pvesm status
   ```

---

## 📞 Support Resources

### Quick Help
- `QUICK-REFERENCE.md` - Common commands
- `SETUP-COMPLETE.md` - Quick start

### Detailed Help
- `HA-SETUP-GUIDE.md` - HA setup issues
- `README-HA-ARR-STACK.md` - Deployment issues
- `DEPLOYMENT-CHECKLIST.md` - Step-by-step help

### Troubleshooting
- Check logs: `journalctl -u corosync`
- Verify connectivity: `./verify-connectivity.sh`
- Check Terraform: `TF_LOG=DEBUG terraform apply`

---

## 🎓 Learning Resources

### Proxmox
- [Proxmox HA Documentation](https://pve.proxmox.com/wiki/High_Availability)
- [Proxmox Cluster Manager](https://pve.proxmox.com/wiki/Cluster_Manager)

### Corosync
- [Corosync QDevice](https://corosync.github.io/corosync/qdevice/)
- [Corosync Documentation](https://corosync.github.io/corosync/)

### Terraform
- [Terraform Proxmox Provider](https://registry.terraform.io/providers/telmate/proxmox/latest/docs)
- [Terraform Documentation](https://www.terraform.io/docs)

### Cloud-Init
- [Cloud-Init Documentation](https://cloud-init.io/)
- [Cloud-Init Examples](https://cloud-init.io/examples/)

---

## 📋 File Checklist

### Terraform Files
- [x] `providers.tf` - Proxmox provider
- [x] `variables.tf` - Variable definitions
- [x] `terraform.tfvars.example` - Example config
- [x] `main.tf` - VM and HA resources

### Cloud-Init Files
- [x] `templates/user-data.yaml` - VM init script
- [x] `templates/network-config.yaml` - Network config

### Scripts
- [x] `setup-qdevice-ha.sh` - QDevice setup
- [x] `verify-connectivity.sh` - Connectivity check

### Documentation
- [x] `SETUP-COMPLETE.md` - Setup status
- [x] `QUICK-REFERENCE.md` - Quick commands
- [x] `HA-SETUP-GUIDE.md` - HA setup guide
- [x] `README-HA-ARR-STACK.md` - Full guide
- [x] `DEPLOYMENT-CHECKLIST.md` - Checklist
- [x] `FILES-CREATED.md` - File descriptions
- [x] `INDEX.md` - This file

---

## 🎯 Next Actions

1. **Verify Connectivity**
   ```bash
   cd /Users/dre/Desktop/Smartmur/Terraform
   ./verify-connectivity.sh
   ```

2. **Setup QDevice HA**
   ```bash
   chmod +x setup-qdevice-ha.sh
   scp setup-qdevice-ha.sh root@192.168.100.100:/tmp/
   ssh root@192.168.100.100 /tmp/setup-qdevice-ha.sh
   ```

3. **Configure Terraform**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   nano terraform.tfvars
   ```

4. **Deploy**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

5. **Verify**
   ```bash
   ssh root@192.168.100.100 qm list
   ssh root@192.168.100.100 ha-manager status
   ```

---

## 📞 Questions?

Refer to the appropriate documentation:
- **Setup**: `SETUP-COMPLETE.md`
- **Commands**: `QUICK-REFERENCE.md`
- **HA Issues**: `HA-SETUP-GUIDE.md`
- **Deployment**: `README-HA-ARR-STACK.md`
- **Step-by-step**: `DEPLOYMENT-CHECKLIST.md`

---

**Status**: ✅ Ready for Deployment
**Last Updated**: 2026-02-14
**Total Files**: 15 (4 Terraform + 2 Cloud-Init + 2 Scripts + 7 Documentation)
**Total Size**: ~60 KB
