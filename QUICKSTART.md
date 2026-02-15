# Quick Start Guide

Get your secure homelab running in minutes!

## ⚡ Fast Track (5 Minutes)

### 1. Initial Setup
```bash
# Clone and initialize
git clone <your-repo>
cd homelab
./scripts/init-homelab.sh
```

### 2. Generate Secrets
```bash
# Run the secret generator
./scripts/generate-secrets.sh

# Choose option 7 for complete service set
# Save the output securely!
```

### 3. Configure Your First Service (Authelia)
```bash
cd Authelia/Authelia

# Edit .env with generated secrets
vim .env
# Replace all CHANGE_ME values

# Update domain
sed -i 's/smartmur.lab/smartmur.lab/g' .env

# Start service
docker-compose up -d

# Check it's running
docker-compose ps
docker-compose logs -f
```

### 4. Access Your Service
Visit: `https://auth.smartmur.lab`

## 🎯 Essential Services Setup

### Traefik (Reverse Proxy) - Required First
```bash
cd Traefikv3
cp .env.example .env

# Edit these values:
# DOMAIN=smartmur.lab
# CF_API_TOKEN=your_cloudflare_token
# ACME_EMAIL=your@email.com

# Create acme.json
touch config/acme.json && chmod 600 config/acme.json

docker-compose up -d
```

### Pi-hole (DNS & Ad Blocking)
```bash
cd Pihole
cp .env.example .env
# Set PIHOLE_PASSWORD
docker-compose up -d
```

### Watchtower (Auto Updates)
```bash
cd Watchtower
cp .env.example .env
# Set WATCHTOWER_HTTP_API_TOKEN
docker-compose up -d
```

## 🔑 Secret Management Cheat Sheet

### Generate Random Secret
```bash
openssl rand -base64 32
```

### Generate Password Hash (Authelia)
```bash
docker run authelia/authelia:latest authelia crypto hash generate argon2 --password 'yourpassword'
```

### Generate htpasswd (Traefik Dashboard)
```bash
echo $(htpasswd -nb admin yourpassword) | sed -e s/\\$/\\$\\$/g
```

## 📁 Repository Structure

```
homelab/
├── scripts/              # Helper scripts
│   ├── init-homelab.sh   # Initial setup
│   ├── generate-secrets.sh
│   ├── validate-secrets.sh
│   └── rotate-secrets.sh
├── Authelia/            # Authentication
├── Traefik/            # Reverse proxy
├── Watchtower/         # Auto-updates
├── README.md           # Main documentation
├── SECURITY.md         # Security guide
├── DEPLOYMENT.md       # Deployment guide
└── MIGRATION-GUIDE.md  # Migration guide
```

## ✅ Pre-Flight Checklist

Before deploying:
- [ ] Docker & Docker Compose installed
- [ ] Domain name configured (or using local DNS)
- [ ] Cloudflare account setup (for SSL)
- [ ] Pre-commit hooks installed: `pre-commit install`
- [ ] All `.env` files created from `.example` files
- [ ] All `CHANGE_ME` values replaced with real secrets
- [ ] Secrets backed up securely (encrypted)

## 🔒 Security Checklist

After deployment:
- [ ] Changed all default passwords
- [ ] Enabled 2FA in Authelia
- [ ] SSL certificates working (HTTPS)
- [ ] Firewall configured (ports 80, 443, 22)
- [ ] Secrets not committed to git (`git status --ignored`)
- [ ] Pre-commit hooks active and testing
- [ ] Backup strategy in place

## 🆘 Quick Troubleshooting

### Service won't start
```bash
docker-compose logs -f
docker-compose config  # Validate syntax
```

### Can't access via domain
```bash
# Check DNS
nslookup smartmur.lab

# Check Traefik
cd Traefikv3
docker-compose logs traefik
```

### Forgot password
```bash
# Authelia: Generate new hash
docker run authelia/authelia:latest authelia crypto hash generate argon2
# Update users_database.yml
```

### Check secrets not exposed
```bash
./scripts/validate-secrets.sh
```

## 📚 Next Steps

1. **Read the full docs:**
   - [README.md](README.md) - Overview
   - [SECURITY.md](SECURITY.md) - Security practices
   - [DEPLOYMENT.md](DEPLOYMENT.md) - Detailed deployment

2. **Add more services:**
   - Browse service directories
   - Copy `.env.example` to `.env`
   - Configure and deploy

3. **Set up monitoring:**
   - Deploy Uptime Kuma
   - Configure Grafana (optional)

4. **Schedule maintenance:**
   - Secret rotation (90 days)
   - System updates (weekly)
   - Backup verification (monthly)

## 💡 Pro Tips

1. **Start small**: Deploy core services first (Traefik, Authelia, Pi-hole)
2. **Test locally**: Use `/etc/hosts` before DNS changes
3. **Keep backups**: Encrypt and store `.env` files safely
4. **Document changes**: Keep notes on customizations
5. **Use labels**: Control Watchtower per container

## 🔗 Useful Commands

```bash
# View all running containers
docker ps

# View all containers (including stopped)
docker ps -a

# Check disk usage
docker system df

# Clean up unused resources
docker system prune -a

# Follow logs for all services
docker-compose logs -f

# Restart a service
docker-compose restart service-name

# Update all images
docker-compose pull
docker-compose up -d
```

## 📞 Get Help

- Check service README: `cat ServiceName/README.md`
- Validate setup: `./scripts/validate-secrets.sh`
- View logs: `docker-compose logs -f`
- Open an issue (never include real secrets!)

---

**Remember:** Security first! Never commit secrets to git. 🔐
