# Proxmox Deployment Guide

Complete guide to deploying the entire homelab stack on Proxmox VE.

## Hardware Requirements by Tier

### Tier 1: Starter (10-15 services)

**Proxmox Host Specs:**
- CPU: 4 cores (Intel i3/i5 or AMD Ryzen 3/5)
- RAM: 16GB
- Storage: 256GB SSD
- Network: 1Gb ethernet

**VM Allocation:**
- VM 1 (Core Services): 2 cores, 4GB RAM, 50GB disk
- VM 2 (Applications): 2 cores, 8GB RAM, 100GB disk
- Proxmox overhead: 4GB RAM

**Services you can run:**
- Traefik, Pi-hole, Authelia, Vaultwarden, Portainer, Uptime Kuma, Jellyfin (1080p), Nextcloud, Gitea, Watchtower

**Monthly cost:** ~$10-15 electricity

---

### Tier 2: Recommended (30-50 services)

**Proxmox Host Specs:**
- CPU: 6-8 cores (Intel i5/i7 or AMD Ryzen 5/7)
- RAM: 32GB
- Storage: 512GB NVMe + 2TB HDD
- Network: 1Gb ethernet

**VM Allocation:**
- VM 1 (Core Services): 2 cores, 4GB RAM, 50GB disk
- VM 2 (Media Stack): 4 cores, 12GB RAM, 100GB disk + 1TB storage
- VM 3 (Applications): 2 cores, 8GB RAM, 100GB disk
- Proxmox overhead: 8GB RAM

**Services you can run:**
- Everything in Tier 1 +
- Jellyfin (4K), Sonarr, Radarr, Prowlarr, qBittorrent, Home Assistant, Grafana, Prometheus, Synapse, Jitsi, Code-Server, Multiple databases

**Monthly cost:** ~$15-25 electricity

---

### Tier 3: Enthusiast/Cluster (100+ services)

**Proxmox Host Specs (3 nodes):**
- CPU: 8+ cores each (Intel i7/i9 or AMD Ryzen 7/9)
- RAM: 64GB each
- Storage: 1TB NVMe + 4TB HDD each
- Network: 10Gb ethernet

**VM Allocation per node:**
- Node 1: Core services + K8s master
- Node 2: Media + storage + K8s worker
- Node 3: Apps + databases + K8s worker

**Services you can run:**
- Unlimited, high availability, Kubernetes cluster

**Monthly cost:** ~$40-60 electricity

---

## Quick Deploy: Starter Setup

This will create a complete homelab on a single Proxmox VM.

### 1. Create Ubuntu VM in Proxmox

In Proxmox web UI:

```bash
# Click "Create VM"
# General:
VM ID: 100
Name: homelab-core

# OS:
ISO: ubuntu-22.04-live-server-amd64.iso

# System:
Graphic card: Default
Machine: q35
BIOS: OVMF (UEFI)
Add EFI Disk: Yes
SCSI Controller: VirtIO SCSI

# Disks:
Bus/Device: SCSI 0
Storage: local-lvm
Disk size: 100 GB
Cache: Write back
Discard: Yes

# CPU:
Cores: 4
Type: host

# Memory:
Memory: 8192 MB
Minimum: 2048 MB
Ballooning: Yes

# Network:
Bridge: vmbr0
Model: VirtIO
```

Click "Finish" then start VM and install Ubuntu.

### 2. SSH Into New VM

```bash
# From your computer
ssh user@VM_IP
```

### 3. Run Complete Setup Script

Copy and paste this entire script (one command):

```bash
curl -sSL https://raw.githubusercontent.com/SmartMur/homelab/main/scripts/proxmox-quick-deploy.sh | bash
```

**What this does:**
- Updates system
- Installs Docker & Docker Compose
- Configures firewall (UFW)
- Sets up directory structure
- Clones homelab repo
- Installs all core services
- Configures automatic backups

**Total time:** 15-20 minutes

---

## Manual Step-by-Step Deployment

If you prefer to do it manually:

### 1. Prepare Ubuntu VM

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y curl git vim ufw

# Set static IP (replace with your network)
sudo nano /etc/netplan/00-installer-config.yaml
```

Add this (adjust for your network):

```yaml
network:
  version: 2
  ethernets:
    ens18:
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
```

Apply:

```bash
sudo netplan apply
```

### 2. Install Docker

```bash
# Docker installation
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose plugin
sudo apt install docker-compose-plugin -y

# Verify
docker --version
docker compose version
```

### 3. Configure Firewall

```bash
# Enable UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow 22/tcp

# Allow Docker services
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw allow 53/tcp   # DNS
sudo ufw allow 53/udp   # DNS
sudo ufw allow 51820/udp # WireGuard

# Enable firewall
sudo ufw enable
```

### 4. Create Directory Structure

```bash
# Create base directories
sudo mkdir -p /data/{docker,config,media,backups,downloads}

# Set permissions
sudo chown -R $USER:$USER /data

# Create service directories
mkdir -p /data/docker/{traefik,pihole,authelia,vaultwarden,jellyfin,nextcloud}
```

### 5. Clone Homelab Repo

```bash
cd ~
git clone https://github.com/SmartMur/homelab.git
cd homelab
```

### 6. Deploy Core Services (Ordered)

Deploy in this exact order:

#### A. Traefik (Reverse Proxy) - FIRST

```bash
cd ~/homelab/Traefikv3

# Copy and configure
cp .env.example .env
nano .env
# Edit: DOMAIN, EMAIL, CF_API_TOKEN

# Deploy
docker compose up -d

# Verify
docker ps | grep traefik
```

#### B. Pi-hole (DNS)

```bash
cd ~/homelab/Pihole

# Deploy
docker compose up -d

# Get password
docker logs pihole | grep "random password"

# Access: http://YOUR_IP/admin
```

#### C. Authelia (2FA)

```bash
cd ~/homelab/Authelia/Authelia

# Copy configs
cp .env.example .env
cp configuration.yml.example configuration.yml
cp users_database.yml.example users_database.yml

# Generate secrets
echo "JWT_SECRET=$(openssl rand -base64 64)" >> .env
echo "SESSION_SECRET=$(openssl rand -base64 64)" >> .env
echo "ENCRYPTION_KEY=$(openssl rand -base64 32)" >> .env
echo "STORAGE_ENCRYPTION_KEY=$(openssl rand -base64 64)" >> .env

# Generate password hash
docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password 'YourPassword'
# Copy hash to users_database.yml

# Edit configs
nano .env
nano users_database.yml

# Deploy
docker compose up -d
```

#### D. Vaultwarden (Passwords)

```bash
cd ~/homelab/Vaultwarden

# Deploy
docker compose up -d

# Access: https://vault.yourdomain.com
```

#### E. Portainer (Docker GUI)

```bash
cd ~/homelab/Portainer

# Deploy
docker compose up -d

# Access: https://portainer.yourdomain.com
```

#### F. Watchtower (Auto-updates)

```bash
cd ~/homelab/Watchtower

# Copy config
cp .env.example .env

# Deploy
docker compose up -d
```

### 7. Deploy Application Services

Now deploy any applications you want:

#### Jellyfin (Media Server)

```bash
cd ~/homelab/Jellyfin

# Edit docker-compose.yml to point to your media
nano docker-compose.yml
# Update: /path/to/your/movies -> /data/media/movies

# Deploy
docker compose up -d

# Access: https://jellyfin.yourdomain.com
```

#### Nextcloud (Cloud Storage)

```bash
cd ~/homelab/Nextcloud

# Deploy (includes database)
docker compose up -d

# Wait 2-3 minutes for initialization
# Access: https://cloud.yourdomain.com
```

#### Uptime Kuma (Monitoring)

```bash
cd ~/homelab/UptimeKuma

# Deploy
docker compose up -d

# Access: https://uptime.yourdomain.com
```

---

## One-Click Deploy Scripts

For even faster deployment, use these scripts:

### Deploy All Core Services

```bash
curl -sSL https://raw.githubusercontent.com/SmartMur/homelab/main/scripts/deploy-core.sh | bash
```

**Deploys:**
- Traefik
- Pi-hole
- Authelia
- Vaultwarden
- Portainer
- Watchtower

**Time:** 5 minutes

### Deploy Media Stack

```bash
curl -sSL https://raw.githubusercontent.com/SmartMur/homelab/main/scripts/deploy-media.sh | bash
```

**Deploys:**
- Jellyfin
- Sonarr
- Radarr
- Prowlarr
- qBittorrent

**Time:** 10 minutes

### Deploy Productivity Stack

```bash
curl -sSL https://raw.githubusercontent.com/SmartMur/homelab/main/scripts/deploy-productivity.sh | bash
```

**Deploys:**
- Nextcloud
- Vikunja
- Trilium
- Gitea

**Time:** 10 minutes

---

## Proxmox Cluster Setup (3 Nodes)

For high availability across multiple Proxmox servers:

### 1. Create Cluster on Node 1

```bash
# On Proxmox node 1
pvecm create homelab-cluster
```

### 2. Join Nodes 2 & 3

```bash
# Get join command from node 1
pvecm status

# On node 2 and 3
pvecm add NODE1_IP
```

### 3. Create Shared Storage

```bash
# Add NFS/Ceph storage to all nodes
# In Proxmox UI: Datacenter -> Storage -> Add
```

### 4. Deploy VMs Across Cluster

```yaml
Node 1: Core Services
- VM 101: Traefik, Authelia, Pi-hole
- VM 102: Databases (PostgreSQL, Redis)

Node 2: Media & Storage
- VM 201: Jellyfin, Media stack
- VM 202: Nextcloud, File storage

Node 3: Applications
- VM 301: Developer tools (Gitea, Code-Server)
- VM 302: Home automation (Home Assistant)
```

### 5. Configure HA

```bash
# Enable HA for critical VMs
ha-manager add vm:101
ha-manager add vm:102
```

---

## Resource Calculator

Use this to estimate what you can run:

```
Available RAM: ___ GB
Reserved for Proxmox: 8GB
Available for VMs: (Total - 8) GB

Per Service RAM Usage:
- Traefik: 256MB
- Pi-hole: 512MB
- Authelia: 512MB
- Vaultwarden: 256MB
- Jellyfin: 2GB (4GB for 4K)
- Nextcloud: 1GB
- Database: 512MB-2GB each
- Home Assistant: 1GB
- Sonarr/Radarr: 512MB each

Example with 32GB total RAM:
32GB - 8GB (Proxmox) = 24GB for VMs

Can run:
- Core services: 4GB
- Jellyfin: 2GB
- Nextcloud: 1GB
- 3x Databases: 3GB
- Misc services: 10GB
= Total: 20GB (4GB buffer)
```

---

## Performance Tuning

### Enable CPU Host Passthrough

Better performance for VMs:

```bash
# In Proxmox UI for each VM:
Hardware -> Processors -> Type -> host
```

### Use VirtIO Drivers

```bash
# When creating VMs:
- Disk: VirtIO SCSI
- Network: VirtIO
- SCSI Controller: VirtIO SCSI single
```

### Enable Disk Caching

```bash
# For each VM disk:
Cache: Write back
Discard: Yes (for SSD)
```

### Optimize Docker

Inside each VM:

```bash
# Create daemon.json
sudo nano /etc/docker/daemon.json
```

Add:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
```

Restart Docker:

```bash
sudo systemctl restart docker
```

---

## Backup Strategy

### Proxmox VM Backups

```bash
# Create backup schedule in Proxmox UI
Datacenter -> Backup -> Add

# Schedule:
- Daily at 2 AM
- Retention: 7 days
- Mode: Snapshot
- Compression: ZSTD
```

### Docker Volume Backups

Inside VMs:

```bash
# Create backup script
sudo nano /usr/local/bin/backup-docker.sh
```

Add:

```bash
#!/bin/bash
BACKUP_DIR="/data/backups"
DATE=$(date +%Y%m%d)

# Stop containers
cd /data/docker/SERVICE_NAME
docker compose down

# Backup
tar -czf $BACKUP_DIR/SERVICE_NAME-$DATE.tar.gz .

# Start containers
docker compose up -d

# Clean old backups (keep 14 days)
find $BACKUP_DIR -name "*.tar.gz" -mtime +14 -delete
```

Make executable:

```bash
sudo chmod +x /usr/local/bin/backup-docker.sh
```

Add to cron:

```bash
crontab -e

# Add:
0 3 * * * /usr/local/bin/backup-docker.sh
```

---

## Monitoring Your Deployment

### Check All Services

```bash
# SSH into VM
cd ~/homelab

# Check all running containers
docker ps

# Check resource usage
docker stats

# Check logs
docker compose -f /data/docker/SERVICE/docker-compose.yml logs -f
```

### Proxmox Monitoring

```bash
# Check VM resources in Proxmox UI
# Or via CLI:
qm status VM_ID
pvesh get /nodes/NODE/qemu/VM_ID/status/current
```

---

## Troubleshooting

### VM Won't Start

```bash
# Check Proxmox logs
tail -f /var/log/pve/tasks/active

# Check VM config
qm config VM_ID
```

### Service Won't Deploy

```bash
# Check Docker logs
docker compose logs SERVICE_NAME

# Check if port is in use
sudo netstat -tulpn | grep PORT

# Check firewall
sudo ufw status
```

### Out of Memory

```bash
# Check memory usage
free -h
docker stats

# Increase VM RAM in Proxmox UI
# Or stop some services
docker compose down -f /data/docker/SERVICE/docker-compose.yml
```

---

## Next Steps

After deployment:

1. Configure DNS (point domains to your server)
2. Set up external access (port forwarding or Cloudflare Tunnel)
3. Configure backups
4. Add monitoring (Uptime Kuma, Grafana)
5. Secure with Authelia
6. Join community and share your setup!

---

## Community Examples

See what others have deployed:

- [Example 1: Minimal Setup](examples/minimal-setup.md)
- [Example 2: Media Server](examples/media-server.md)
- [Example 3: Full Stack](examples/full-stack.md)

Share yours on r/homelab!
