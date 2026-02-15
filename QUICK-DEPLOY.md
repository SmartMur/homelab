# Quick Deploy Guide

Get your entire homelab running in under 30 minutes.

## Prerequisites

- Fresh Ubuntu 22.04 server (VM or bare metal)
- 8GB+ RAM
- 50GB+ storage
- Internet connection
- Domain name (optional but recommended)

## Method 1: Fully Automated (5 minutes)

One command deploys everything:

```bash
curl -sSL https://raw.githubusercontent.com/SmartMur/homelab/main/scripts/install-homelab.sh | bash
```

This will:
1. Install Docker
2. Configure firewall
3. Clone repository
4. Deploy core services
5. Set up monitoring

**What you get:**
- Traefik (reverse proxy)
- Pi-hole (DNS/ad blocking)
- Vaultwarden (password manager)
- Portainer (Docker UI)
- Watchtower (auto-updates)
- Uptime Kuma (monitoring)

**Total time:** 5-10 minutes

---

## Method 2: Step-by-Step (30 minutes)

### Step 1: Install Docker (2 minutes)

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

Log out and back in, then verify:

```bash
docker --version
```

### Step 2: Clone Repository (1 minute)

```bash
cd ~
git clone https://github.com/SmartMur/homelab.git
cd homelab
```

### Step 3: Deploy Core Services (10 minutes)

```bash
./scripts/deploy-core.sh
```

When prompted, enter:
- Your domain name
- Your email
- Cloudflare API token (optional)

### Step 4: Deploy Applications (15 minutes)

Choose what you want:

**Media Server:**
```bash
./scripts/deploy-media.sh
```

**Cloud Storage:**
```bash
cd ~/homelab/Nextcloud
docker compose up -d
```

**Developer Tools:**
```bash
cd ~/homelab/Gitea
docker compose up -d
```

**Home Automation:**
```bash
cd ~/homelab/Home-Assistant
docker compose up -d
```

### Step 5: Verify Everything (2 minutes)

```bash
docker ps
```

You should see all your containers running!

---

## Method 3: Manual Service-by-Service

Deploy exactly what you want, in order:

### 1. Traefik (MUST BE FIRST)

```bash
cd ~/homelab/Traefikv3
cp .env.example .env
nano .env  # Edit DOMAIN, EMAIL, CF_API_TOKEN
docker compose up -d
```

### 2. Pi-hole

```bash
cd ~/homelab/Pihole
docker compose up -d
docker logs pihole | grep "password"  # Save this!
```

### 3. Vaultwarden

```bash
cd ~/homelab/Vaultwarden
docker compose up -d
```

### 4. Portainer

```bash
cd ~/homelab/Portainer
docker compose up -d
```

### 5. Any Other Service

```bash
cd ~/homelab/SERVICE_NAME
docker compose up -d
```

---

## Quick Commands Reference

### Check All Running Services

```bash
docker ps
```

### Check Logs

```bash
# Specific service
docker logs SERVICE_NAME

# Follow logs (live)
docker logs -f SERVICE_NAME

# Via compose
cd ~/homelab/SERVICE_NAME
docker compose logs -f
```

### Restart Service

```bash
cd ~/homelab/SERVICE_NAME
docker compose restart
```

### Stop Service

```bash
cd ~/homelab/SERVICE_NAME
docker compose down
```

### Update Service

```bash
cd ~/homelab/SERVICE_NAME
docker compose pull
docker compose up -d
```

### Update All Services

```bash
cd ~/homelab
for dir in */; do
  if [ -f "$dir/docker-compose.yml" ]; then
    echo "Updating $dir"
    cd "$dir"
    docker compose pull
    docker compose up -d
    cd ..
  fi
done
```

---

## Resource Usage Quick Reference

After deploying, check resource usage:

```bash
# CPU and RAM usage
docker stats

# Disk usage
docker system df

# Detailed disk usage
du -sh ~/homelab/*
```

**Typical resource usage:**

```
Core Services (~4GB RAM):
- Traefik:     ~50MB
- Pi-hole:     ~200MB
- Vaultwarden: ~50MB
- Portainer:   ~50MB
- Watchtower:  ~20MB
- Authelia:    ~100MB

Media Services (~4GB RAM):
- Jellyfin:    ~500MB (2GB when streaming)
- Nextcloud:   ~500MB
- Databases:   ~200MB each

Total for 10-15 services: 6-8GB RAM
```

---

## Troubleshooting Quick Fixes

### Service Won't Start

```bash
# Check logs
docker logs SERVICE_NAME

# Check if port is in use
sudo netstat -tulpn | grep PORT

# Restart
docker restart SERVICE_NAME
```

### Can't Access Web UI

```bash
# Check if running
docker ps | grep SERVICE_NAME

# Check Traefik
docker logs traefik | grep SERVICE_NAME

# Check DNS
nslookup service.yourdomain.com
```

### Out of Disk Space

```bash
# Clean up Docker
docker system prune -a

# Remove unused volumes
docker volume prune
```

### Container Keeps Restarting

```bash
# Check logs for errors
docker logs SERVICE_NAME

# Check .env file
cat ~/homelab/SERVICE_NAME/.env

# Check permissions
ls -la ~/homelab/SERVICE_NAME/
```

---

## Common Deployment Patterns

### Pattern 1: Minimal (1 VM, 8GB RAM)

```bash
# Core only
./scripts/deploy-core.sh
```

Services: Traefik, Pi-hole, Vaultwarden, Portainer

### Pattern 2: Media Server (1 VM, 16GB RAM)

```bash
# Core + Media
./scripts/deploy-core.sh
./scripts/deploy-media.sh
```

Services: Core + Jellyfin

### Pattern 3: Full Stack (1 VM, 32GB RAM)

```bash
# Everything
./scripts/deploy-core.sh
./scripts/deploy-media.sh
./scripts/deploy-productivity.sh
```

Services: 20-30 services

### Pattern 4: Multi-VM (Proxmox)

```
VM 1 (Core): Traefik, Pi-hole, Authelia
VM 2 (Media): Jellyfin, *arr stack
VM 3 (Apps): Nextcloud, Gitea, etc.
```

See [PROXMOX-DEPLOYMENT.md](PROXMOX-DEPLOYMENT.md)

---

## Post-Deployment Checklist

After deploying services:

- [ ] All containers running (`docker ps`)
- [ ] Can access Traefik dashboard
- [ ] Pi-hole blocking ads
- [ ] Vaultwarden accessible
- [ ] Portainer showing containers
- [ ] DNS configured
- [ ] Firewall configured
- [ ] Backups scheduled
- [ ] Monitoring set up
- [ ] Documentation updated with your IPs/domains

---

## Getting Help

If something doesn't work:

1. Check logs: `docker logs SERVICE_NAME`
2. Verify config: `cat .env`
3. Test connection: `curl -I http://localhost:PORT`
4. Search issues: [GitHub Issues](https://github.com/SmartMur/homelab/issues)
5. Ask community: r/homelab or r/selfhosted

---

## What's Next?

After basic deployment:

1. **Secure it:**
   - Deploy Authelia for 2FA
   - Configure firewall rules
   - Set up VPN access

2. **Monitor it:**
   - Deploy Uptime Kuma
   - Set up Grafana + Prometheus
   - Configure alerts

3. **Back it up:**
   - Schedule automated backups
   - Test restore process
   - Document recovery steps

4. **Share it:**
   - Post your setup on r/homelab
   - Contribute improvements
   - Help other beginners

---

## Example: Complete Fresh Server to Running Homelab

```bash
# Start with fresh Ubuntu 22.04 server
# SSH in

# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Log out and back in
exit
ssh user@server

# Deploy everything
curl -sSL https://raw.githubusercontent.com/SmartMur/homelab/main/scripts/install-homelab.sh | bash

# Enter your domain and email when prompted

# Wait 10 minutes

# Done! Access services at:
# - https://traefik.yourdomain.com
# - https://vault.yourdomain.com
# - https://portainer.yourdomain.com
```

**Total time: 15 minutes**

That's it! You now have a production-ready homelab.
