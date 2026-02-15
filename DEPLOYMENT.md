# Deployment Guide

Step-by-step guide to deploy your homelab infrastructure securely.

## Prerequisites

- Docker & Docker Compose installed
- Git installed
- Basic understanding of Docker and networking
- Domain name (optional but recommended)
- SSL certificates or Cloudflare account (for HTTPS)

## Initial Deployment

### 1. Clone and Setup

```bash
# Clone repository
git clone <your-repo>
cd homelab

# Run initial setup
./scripts/init-homelab.sh
```

### 2. Configure Core Services First

Start with essential services in this order:

#### A. Traefik (Reverse Proxy)

```bash
cd Traefikv3

# Configure
vim .env
# Set:
# - DOMAIN=smartmur.lab
# - CF_API_TOKEN=your_token
# - ACME_EMAIL=your@email.com

# Create required files
touch config/acme.json
chmod 600 config/acme.json

# Start
docker-compose up -d

# Verify
docker-compose logs -f
```

#### B. Authelia (Authentication)

```bash
cd ../Authelia/Authelia

# Generate secrets
openssl rand -base64 64  # Run 3 times for JWT, Session, Encryption

# Configure .env
vim .env
# Add generated secrets

# Update domain in configuration.yml
vim configuration.yml
# Update AUTHELIA_DOMAIN

# Create user
docker run authelia/authelia:latest authelia crypto hash generate argon2 --password 'your-password'

# Add to users_database.yml
vim users_database.yml

# Start
docker-compose up -d

# Test login
# Visit: https://auth.smartmur.lab
```

#### C. Pi-hole (DNS)

```bash
cd ../../Pihole

# Configure
vim .env
# Set PIHOLE_PASSWORD

# Start
docker-compose up -d

# Access dashboard
# Visit: https://pihole.smartmur.lab
```

### 3. Deploy Additional Services

Once core services work, deploy others:

```bash
# Watchtower (automatic updates)
cd Watchtower
cp .env.example .env
vim .env  # Set WATCHTOWER_HTTP_API_TOKEN
docker-compose up -d

# Uptime Kuma (monitoring)
cd ../UptimeKuma
docker-compose up -d

# Add more services as needed
```

## Service-Specific Guides

### Jellyfin/Plex Media Server

```bash
cd Jellyfin

# Configure storage paths
vim docker-compose.yaml
# Update volume paths to your media location

docker-compose up -d
```

### Nextcloud

```bash
cd Nextcloud

vim .env
# Set database passwords

docker-compose up -d

# First-time setup via web UI
# Create admin account
```

### Vaultwarden (Password Manager)

```bash
cd Vaultwarden

vim .env
# Set admin token

docker-compose up -d
```

## Network Configuration

### Create Traefik Network

```bash
docker network create proxy
```

### Port Forwarding

Forward these ports on your router:
- `80/tcp` - HTTP (redirects to HTTPS)
- `443/tcp` - HTTPS
- `51820/udp` - WireGuard VPN (if using)

### DNS Configuration

Point your domain to your public IP:

```
A     @              your.public.ip
A     *              your.public.ip
```

Or use Cloudflare Proxy for additional protection.

## SSL/TLS Configuration

### Option 1: Let's Encrypt (Recommended)

Traefik handles this automatically with DNS challenge:

```yaml
# Already configured in Traefik docker-compose
# Ensure CF_API_TOKEN is set correctly
```

### Option 2: Self-Signed Certificates

```bash
# Generate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout selfsigned.key -out selfsigned.crt

# Add to Traefik configuration
```

## Security Hardening

### 1. Enable Firewall

```bash
# UFW (Ubuntu)
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
```

### 2. Configure Fail2ban

```bash
sudo apt install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 3. Regular Updates

```bash
# System updates
sudo apt update && sudo apt upgrade -y

# Container updates (Watchtower handles automatically)
# Or manually:
docker-compose pull
docker-compose up -d
```

### 4. Backup Configuration

```bash
# Backup script
#!/bin/bash
DATE=$(date +%Y%m%d)
tar -czf homelab-backup-$DATE.tar.gz \
  $(find . -name ".env") \
  $(find . -name "docker-compose.yaml") \
  Authelia/Authelia/users_database.yml \
  Authelia/Authelia/configuration.yml

# Encrypt backup
gpg -c homelab-backup-$DATE.tar.gz
rm homelab-backup-$DATE.tar.gz

# Store encrypted backup securely
```

## Monitoring

### Check Service Health

```bash
# All services
docker ps

# Specific service
cd ServiceName
docker-compose ps
docker-compose logs -f
```

### Uptime Kuma

Configure monitors for all services:
- HTTP(s) checks
- Docker container checks
- Ping checks

### Grafana (Optional)

Full metrics stack:
```bash
cd Grafana-Monitoring
vim .env
docker-compose up -d
```

## Troubleshooting

### Service Won't Start

```bash
# Check logs
docker-compose logs service-name

# Validate compose file
docker-compose config

# Check .env loaded
docker-compose config | grep -A 5 environment
```

### Can't Access via Domain

1. Check DNS propagation: `nslookup smartmur.lab`
2. Verify port forwarding
3. Check Traefik logs: `docker-compose logs traefik`
4. Verify SSL certificates: `docker-compose exec traefik cat /acme.json`

### SSL Certificate Issues

```bash
# Check Traefik logs
docker-compose logs traefik | grep -i acme

# Verify DNS challenge works
# Check Cloudflare API token permissions

# Manual certificate generation test
docker-compose exec traefik sh
```

### Authentication Issues (Authelia)

```bash
# Check Authelia logs
cd Authelia/Authelia
docker-compose logs -f

# Validate config
docker-compose exec authelia authelia validate-config

# Reset user password
# Generate new hash and update users_database.yml
```

## Maintenance Schedule

### Daily
- Check Uptime Kuma dashboard
- Review critical service logs

### Weekly
- Review Watchtower update logs
- Check disk space usage
- Verify backups completed

### Monthly
- Update system packages
- Review and rotate logs
- Test backup restoration

### Quarterly (90 days)
- Rotate secrets (./scripts/rotate-secrets.sh)
- Review and update access controls
- Security audit

## Scaling

### Adding More Services

```bash
# 1. Add service to repository
# 2. Create .env.example
# 3. Configure docker-compose.yaml
# 4. Add Traefik labels
# 5. Document in README
# 6. Deploy
cd NewService
cp .env.example .env
vim .env
docker-compose up -d
```

### High Availability

For production HA:
- Use Kubernetes instead (see Kubernetes/ directory)
- Multiple Traefik instances
- External database for Authelia
- Redis cluster
- Shared storage (NFS/Ceph)

## Rollback Procedure

If deployment fails:

```bash
# 1. Stop services
docker-compose down

# 2. Restore from backup
tar -xzf homelab-backup-YYYYMMDD.tar.gz

# 3. Restore specific service
cd ServiceName
docker-compose down
# Restore .env and docker-compose.yaml
docker-compose up -d

# 4. Check logs
docker-compose logs -f
```

## Getting Help

1. Check service-specific README files
2. Review logs: `docker-compose logs -f`
3. Run validation: `./scripts/validate-secrets.sh`
4. Check Docker: `docker ps -a`
5. Open an issue (never include secrets!)

---

**Pro Tip:** Deploy incrementally. Don't start all services at once. Verify each service works before adding the next.
