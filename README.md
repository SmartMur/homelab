# Homelab Infrastructure Repository

A comprehensive, security-focused homelab infrastructure repository with Docker Compose configurations for self-hosted services.

## 🔒 Security First

This repository has been designed with **security as the top priority**:

✅ **No hardcoded secrets** - All credentials externalized to `.env` files  
✅ **Pre-commit hooks** - Prevent accidental secret commits  
✅ **Ansible Vault** - Encrypted secrets for automation  
✅ **Template-based configs** - Safe examples for all sensitive files  
✅ **Automated validation** - Scripts to verify secure configuration  

## 🚀 Quick Start

### 1. Initial Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd <repo-name>

# Run the setup wizard
./scripts/init-homelab.sh
```

This will:
- Install pre-commit hooks
- Create `.env` files from templates
- Set up configuration files
- Guide you through secret generation

### 2. Configure Secrets

```bash
# Generate secure secrets
./scripts/generate-secrets.sh

# Update .env files with generated secrets
# Each service directory has a .env.example - copy to .env and customize
find . -name ".env.example" -exec sh -c 'cp "$1" "${1%.example}"' _ {} \;
```

### 3. Update Configuration

Edit the following for your environment:
- **Domain names** in `.env` files
- **Email addresses** for Let's Encrypt
- **API tokens** from your service providers
- **Passwords** for services (use generated secrets)

### 4. Deploy Services

```bash
# Navigate to a service directory
cd Authelia/Authelia

# Start the service
docker-compose up -d

# Check logs
docker-compose logs -f
```

## 📁 Repository Structure

```
.
├── Authelia/          # Authentication & SSO
├── Traefik/          # Reverse proxy
├── Watchtower/       # Container auto-updates
├── Nginx/            # Web server
├── Ansible/          # Infrastructure automation
├── Kubernetes/       # K8s deployments
├── scripts/          # Helper scripts
│   ├── generate-secrets.sh
│   ├── validate-secrets.sh
│   ├── rotate-secrets.sh
│   └── init-homelab.sh
├── SECURITY.md       # Security documentation
└── README.md         # This file
```

## 🛡️ Security Features

### Environment Variables
All sensitive configuration uses `.env` files:
- ✅ Gitignored by default
- ✅ Template files (`.env.example`) provided
- ✅ Validated by pre-commit hooks

### Ansible Vault
Ansible secrets are encrypted:
```bash
# Create encrypted secrets
ansible-vault create Ansible/Playbooks/Secrets-Variables/secrets.yml

# Edit encrypted secrets
ansible-vault edit Ansible/Playbooks/Secrets-Variables/secrets.yml
```

### Pre-commit Hooks
Automatic validation before commits:
- Detects `.env` files
- Catches credential files
- Scans for hardcoded secrets
- Validates YAML syntax

### Helper Scripts

**Generate Secrets:**
```bash
./scripts/generate-secrets.sh
```

**Validate Configuration:**
```bash
./scripts/validate-secrets.sh
```

**Rotate Secrets:**
```bash
./scripts/rotate-secrets.sh
```

## 📦 Available Services

### Security & Authentication
- **Authelia** - 2FA & SSO authentication
- **Authentik** - Identity provider
- **Vaultwarden** - Password manager

### Networking
- **Traefik** - Reverse proxy with automatic SSL
- **Pi-hole** - Network-wide ad blocking
- **WireGuard** - VPN server
- **Headscale** - Self-hosted Tailscale

### Monitoring
- **Grafana** - Metrics visualization
- **Uptime Kuma** - Uptime monitoring
- **Watchtower** - Container updates

### Media & Storage
- **Jellyfin** / **Plex** - Media servers
- **Nextcloud** - File sync & share
- **Immich** - Photo management
- **Paperless-ngx** - Document management

### Development
- **Gitea** - Git hosting
- **Code Server** - VS Code in browser
- **Portainer** - Docker management

### Communication
- **Synapse** - Matrix homeserver
- **Gotify** - Push notifications
- **Jitsi** - Video conferencing

...and many more! See individual directories for details.

## 🔧 Configuration Examples

### Authelia Setup
```bash
cd Authelia/Authelia
cp .env.example .env
cp configuration.yml.example configuration.yml
cp users_database.yml.example users_database.yml

# Generate secrets
openssl rand -base64 64  # For JWT, Session secrets

# Edit .env with your secrets
vim .env

# Start service
docker-compose up -d
```

### Traefik with Cloudflare
```bash
cd Traefikv3
cp .env.example .env

# Add your Cloudflare API token to .env
# CF_API_TOKEN=your_token_here

docker-compose up -d
```

## 📖 Documentation

- **[SECURITY.md](SECURITY.md)** - Security best practices
- **Service READMEs** - Each service has detailed docs in its directory
- **Ansible Documentation** - See `Ansible/` directories

## 🔄 Maintenance

### Regular Tasks

**Update containers:**
```bash
# Watchtower does this automatically, or manually:
docker-compose pull
docker-compose up -d
```

**Rotate secrets (every 90 days recommended):**
```bash
./scripts/rotate-secrets.sh
```

**Validate configuration:**
```bash
./scripts/validate-secrets.sh
```

**Backup important data:**
```bash
# Backup .env files (encrypted)
# Backup docker volumes
# Backup Ansible vault files
```

### Troubleshooting

**Service won't start:**
```bash
# Check logs
docker-compose logs -f service-name

# Validate compose file
docker-compose config

# Check .env file
cat .env | grep CHANGE_ME  # Should have no results
```

**Secrets validation fails:**
```bash
# Run validation script
./scripts/validate-secrets.sh

# Check what's not gitignored
git status --ignored
```

## 🤝 Contributing

Before contributing:
1. Install pre-commit hooks: `pre-commit install`
2. Never commit real secrets
3. Use `.example` files for sensitive configs
4. Test changes in a dev environment

## ⚠️ Important Notes

1. **Never commit `.env` files** - They contain your actual secrets
2. **Always use `.env.example`** - For sharing configurations
3. **Rotate secrets regularly** - At least every 90 days
4. **Backup your data** - Especially vault passwords and important configs
5. **Test before production** - Always test in dev environment first

## 📜 License

[Your License Here]

## 🙏 Credits

This repository aggregates configurations for various open-source projects. Credit to all the amazing developers behind these services.

## 📞 Support

- Open an issue for bugs or questions
- Review `SECURITY.md` for security concerns
- Check individual service READMEs for specific issues

---

**Remember:** Security is a journey, not a destination. Keep your secrets secret! 🔐
