# Homelab Infrastructure Repository

> 🏠 A comprehensive, security-focused collection of **90+ self-hosted services** for your homelab journey

---

## 🎯 New to Homelabs? **START HERE!**

Feeling overwhelmed by 90+ folders? Don't worry - we've got you covered!

👉 **First time?** Jump to the [👶 Beginner's Journey](#-beginners-journey---your-first-30-days) (Week-by-week roadmap)  
👉 **Know Docker?** Check the [📊 Service Catalog](#-complete-service-catalog) (Find what you need)  
👉 **Ready to deploy?** Go to [🚀 Quick Start](#-quick-start)  
👉 **Questions?** Read the [❓ FAQ](#-frequently-asked-questions)

---

## 💻 Hardware Requirements

Not sure if your hardware can handle this? Here's what you need:

| Setup | Hardware | Services | Monthly Cost | Perfect For |
|-------|----------|----------|--------------|-------------|
| 🟢 **Starter** | Raspberry Pi 4 (4GB)<br>Old laptop/PC | 5-10 lightweight | ~$5-10 electricity | Learning & testing |
| 🟡 **Recommended** | Intel NUC / Mini PC<br>4 cores, 16GB RAM | 20-30 services | ~$10-15 electricity | Most homelabbers |
| 🔴 **Enthusiast** | Custom server<br>8+ cores, 32-64GB RAM | Unlimited | ~$20-30 electricity | Power users |

**One-time hardware cost:** $150 (Starter) • $400-600 (Recommended) • $1000+ (Enthusiast)

---

## ✅ Prerequisites Checklist

Before you start, make sure you have:

### Required Knowledge
- [ ] **Linux basics** - Can navigate terminal and edit files
- [ ] **Docker fundamentals** - Understand what containers are
- [ ] **Networking basics** - Know what IP addresses, ports, and DNS mean
- [ ] **Text editing** - Comfortable with nano/vim or VS Code

**Missing skills?** See [📚 Learning Resources](#-learning-resources) below

### Required Software
- [ ] Docker Engine 20.10+ ([Install guide](https://docs.docker.com/engine/install/))
- [ ] Docker Compose V2 ([Install guide](https://docs.docker.com/compose/install/))
- [ ] Git ([Install guide](https://git-scm.com/downloads))
- [ ] A text editor (VS Code, nano, vim)

### Optional but Recommended
- [ ] Domain name ($10-15/year from Cloudflare, Namecheap, etc.)
- [ ] Cloudflare account (free tier works great)
- [ ] Basic YAML knowledge

---

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

## 💡 "I Want To..." - Use Case Guide

**Not sure which services to choose?** Here's what to deploy based on your goals:

### 🎯 "I want to replace Google/Microsoft services"
- **Google Drive** → Deploy `Nextcloud`
- **Google Photos** → Deploy `Immich`
- **Gmail** (webmail) → Deploy `Mailcow` (advanced) or use external
- **Google Calendar/Contacts** → Deploy `Nextcloud` (includes these!)
- **Google Docs** → Deploy `Nextcloud` + `Collabora` or `OnlyOffice`
- **Google Keep** → Deploy `Trilium` or `Vikunja`
- **Chrome Password Manager** → Deploy `Vaultwarden`

### 🎬 "I want a home media center"
1. Deploy `Traefik` (reverse proxy)
2. Deploy `Jellyfin` or `Plex` (media server)
3. Deploy `Sonarr/Radarr` (media management - not in repo, add yourself)
4. Deploy `Immich` (photo backup)
5. Deploy `Paperless-ngx` (document organization)

### 🔒 "I want maximum security & privacy"
1. Deploy `Traefik` (reverse proxy with SSL)
2. Deploy `Authelia` (2FA on everything)
3. Deploy `Vaultwarden` (password manager)
4. Deploy `WireGuard` (VPN only access)
5. Deploy `Pi-hole` (block trackers)
6. Deploy `Crowdsec` (automated threat blocking)
7. Never expose ports directly!

### 🏠 "I want a smart home"
1. Deploy `Home-Assistant` (central control)
2. Deploy `Mosquitto` (MQTT broker)
3. Deploy `Zigbee2MQTT` (Zigbee devices)
4. Deploy `Node-RED` (automation - add yourself)
5. Deploy `Frigate` (security cameras)
6. Deploy `Grafana-Monitoring` (visualize data)

### 💼 "I want a development environment"
1. Deploy `Gitea` (Git hosting)
2. Deploy `Code-Server` (VS Code in browser)
3. Deploy `Portainer` (Docker management)
4. Deploy `IT-Tools` (developer utilities)
5. Deploy `Uptime Kuma` (monitor projects)

### 📚 "I want a knowledge base"
1. Deploy `Trilium` (hierarchical notes)
2. Deploy `Nextcloud` (file storage + collaboration)
3. Deploy `Paperless-ngx` (document scanning)
4. Deploy `Linkwarden` (bookmark everything)
5. Deploy `SearXNG` (private search)

### 🎮 "I want to host game servers"
1. Deploy `Minecraft` (Minecraft server)
2. Deploy `Pterodactyl` (game server panel)
3. Deploy `Traefik` (manage web access)
4. Deploy `Uptime Kuma` (monitor uptime)

### 📡 "I want remote access from anywhere"
**Option 1: VPN (Most Secure)**
1. Deploy `WireGuard` or `Headscale`
2. Connect via VPN app
3. Access everything as if you're home

**Option 2: Cloudflare Tunnel (No Port Forwarding)**
1. Deploy `Cloudflare-Tunnel`
2. Deploy `Authelia` (2FA)
3. Access via cloudflare tunnels

**Option 3: Traditional Reverse Proxy**
1. Deploy `Traefik`
2. Deploy `Authelia` (2FA required!)
3. Forward ports 80 & 443
4. Use strong passwords!

---

## 📁 Repository Structure

```
.
├── 🔐 Security & Auth/
│   ├── Authelia/          # 2FA & SSO
│   ├── Authentik/         # Identity provider
│   └── Vaultwarden/       # Password manager
│
├── 🌐 Networking/
│   ├── Traefik/           # Reverse proxy
│   ├── Pihole/            # DNS & ad blocking
│   └── Wireguard/         # VPN server
│
├── 📊 Monitoring/
│   ├── UptimeKuma/        # Uptime monitoring
│   ├── Grafana-Monitoring/# Metrics & dashboards
│   └── Watchtower/        # Auto-updates
│
├── 🎬 Media/
│   ├── Jellyfin/          # Media server
│   ├── Immich/            # Photo management
│   └── Paperless-ngx/     # Documents
│
├── ☁️ Productivity/
│   ├── Nextcloud/         # File sync
│   ├── Vikunja/           # Task management
│   └── Trilium/           # Notes
│
├── 🏗️ Infrastructure/
│   ├── Ansible/           # Automation playbooks
│   ├── Terraform/         # Infrastructure as code
│   ├── Kubernetes/        # K8s deployments
│   └── Docker-Swarm/      # Swarm configs
│
├── 🛠️ Scripts & Tools/
│   ├── scripts/
│   │   ├── generate-secrets.sh
│   │   ├── validate-secrets.sh
│   │   ├── rotate-secrets.sh
│   │   └── init-homelab.sh
│
└── 📖 Documentation/
    ├── README.md          # This file
    ├── QUICKSTART.md      # Quick start guide
    ├── SECURITY.md        # Security best practices
    ├── DEPLOYMENT.md      # Deployment guide
    └── CONTRIBUTING.md    # Contribution guidelines
```

**Total: 90+ services across 15+ categories!**

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

## 📊 Complete Service Catalog

> 💡 **Tip:** Services marked 🟢 are beginner-friendly. Start with those!

### 🔐 Security & Authentication (Start Here!)
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Traefik** / **Traefikv3** | Reverse proxy with automatic SSL | 🟢 Beginner | 256MB | Routes traffic to services, handles HTTPS |
| **Authelia** | 2FA & Single Sign-On | 🟡 Intermediate | 512MB | Adds 2FA to all services (like Google Authenticator) |
| **Authentik** | Identity provider (alternative to Authelia) | 🔴 Advanced | 1GB | Enterprise-grade auth system |
| **Vaultwarden** | Password manager (Bitwarden) | 🟢 Beginner | 256MB | Store all passwords securely |
| **Keycloak** | Enterprise identity management | 🔴 Advanced | 2GB | OAuth/SAML provider |
| **Pocket-ID** | Simple SSO provider | 🟡 Intermediate | 256MB | Lightweight authentication |
| **Tinyauth** | Minimal auth proxy | 🟢 Beginner | 128MB | Basic HTTP authentication |
| **BunkerWeb** | Web application firewall | 🔴 Advanced | 512MB | Advanced security layer |
| **SafeLine** | WAF & security platform | 🔴 Advanced | 1GB | Chinese web application firewall |

### 🌐 Networking & DNS
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Pihole** / **Piholev6** | Network-wide ad blocking | 🟢 Beginner | 512MB | Block ads for entire network |
| **Unbound** | Recursive DNS resolver | 🟡 Intermediate | 256MB | Privacy-focused DNS |
| **Nginx** | Web server & reverse proxy | 🟡 Intermediate | 256MB | Serve websites |
| **Caddy** | Web server with auto HTTPS | 🟢 Beginner | 256MB | Easy alternative to Nginx |
| **Cloudflare-Tunnel** | Secure tunnel without port forwarding | 🟡 Intermediate | 128MB | Access services without opening ports |
| **WireGuard** | Fast VPN server | 🟡 Intermediate | 256MB | Secure remote access |
| **Headscale** / **Headscale2** | Self-hosted Tailscale | 🔴 Advanced | 256MB | Mesh VPN network |
| **Netbird** | WireGuard mesh network | 🟡 Intermediate | 256MB | Alternative to Tailscale |
| **OpenVPN** (in Torrent-VPN) | Traditional VPN | 🟡 Intermediate | 256MB | VPN for specific containers |

### 📊 Monitoring & Management
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **UptimeKuma** | Uptime monitoring | 🟢 Beginner | 256MB | Monitor service availability |
| **Watchtower** | Automatic container updates | 🟢 Beginner | 128MB | Keep containers updated |
| **Portainer** | Docker GUI management | 🟢 Beginner | 256MB | Manage Docker with web UI |
| **Grafana-Monitoring** | Metrics & dashboards | 🟡 Intermediate | 512MB | Visualize performance data |
| **Checkmk** | Infrastructure monitoring | 🔴 Advanced | 1GB | Enterprise monitoring |
| **Wazuh** | Security monitoring | 🔴 Advanced | 4GB | SIEM & threat detection |
| **DIUN** | Docker image update notifier | 🟢 Beginner | 64MB | Get notified of updates |
| **Homepage** | Dashboard homepage | 🟢 Beginner | 128MB | Central dashboard |
| **Checkmate** | Status page | 🟢 Beginner | 128MB | Public status page |
| **Crowdsec** | Collaborative security | 🔴 Advanced | 512MB | Automated threat blocking |

### 🎬 Media & Entertainment
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Jellyfin** | Media server (free Plex) | 🟡 Intermediate | 2GB | Stream movies/TV shows |
| **Plex** | Popular media server | 🟡 Intermediate | 2GB | Stream media (paid features) |
| **Immich** | Photo management (Google Photos alternative) | 🟡 Intermediate | 2GB | Self-hosted photo backup |
| **Ente** | Encrypted photo storage | 🟡 Intermediate | 1GB | Privacy-focused photos |
| **Frigate** | NVR with object detection | 🔴 Advanced | 2GB+ | Security camera management |
| **Deconz** | Zigbee gateway | 🔴 Advanced | 512MB | Smart home device control |

### ☁️ Productivity & Storage
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Nextcloud** | File sync & share (Dropbox alternative) | 🟡 Intermediate | 1GB | Cloud storage & collaboration |
| **Paperless-ngx** | Document management | 🟡 Intermediate | 1GB | Organize scanned documents |
| **Trilium** | Note-taking app | 🟢 Beginner | 256MB | Hierarchical notes |
| **Vikunja** | Task management | 🟢 Beginner | 256MB | To-do lists & projects |
| **Linkwarden** | Bookmark manager | 🟢 Beginner | 256MB | Save & organize links |
| **Hoarder** | Bookmark & content saver | 🟢 Beginner | 256MB | Save web content |
| **Twenty** | CRM system | 🟡 Intermediate | 512MB | Customer relationship management |
| **Enclosed** | Secure file sharing | 🟢 Beginner | 128MB | Send encrypted files |
| **PrivateBin** | Pastebin alternative | 🟢 Beginner | 64MB | Share text securely |

### 💬 Communication & Collaboration
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Synapse** | Matrix homeserver | 🔴 Advanced | 1GB | Self-hosted chat (like Discord) |
| **Gotify** | Push notifications | 🟢 Beginner | 128MB | Send alerts to your phone |
| **Jitsi** | Video conferencing | 🟡 Intermediate | 2GB | Self-hosted Zoom alternative |
| **MiroTalk** | Video chat | 🟢 Beginner | 512MB | Simple video calls |
| **RustDesk** | Remote desktop | 🟡 Intermediate | 256MB | TeamViewer alternative |

### 🛠️ Development & DevOps
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Gitea** | Git hosting | 🟡 Intermediate | 512MB | Self-hosted GitHub |
| **Code-Server** | VS Code in browser | 🟢 Beginner | 512MB | Code from anywhere |
| **IT-Tools** | Developer utilities | 🟢 Beginner | 128MB | Handy dev tools |
| **Omni-Tools** | All-in-one tools | 🟢 Beginner | 256MB | Multiple utilities |
| **Postiz** | Social media scheduler | 🟡 Intermediate | 512MB | Schedule posts |

### 🏠 Home Automation
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Home-Assistant** | Home automation platform | 🔴 Advanced | 1GB | Control smart home devices |
| **Mosquitto** | MQTT broker | 🟡 Intermediate | 128MB | IoT device messaging |
| **Zigbee2MQTT** | Zigbee to MQTT bridge | 🔴 Advanced | 256MB | Connect Zigbee devices |

### 🎮 Gaming & Fun
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Minecraft** | Minecraft server | 🟡 Intermediate | 2GB+ | Host game server |
| **Pterodactyl** | Game server panel | 🔴 Advanced | 1GB | Manage game servers |

### 🔄 Backup & Sync
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **rClone** | Cloud sync | 🟡 Intermediate | 256MB | Sync to cloud storage |
| **restic** | Encrypted backups | 🟡 Intermediate | 256MB | Backup files securely |
| **Duplicati** (in Proxmox-Backup-Server) | Backup solution | 🟡 Intermediate | 512MB | Automated backups |

### 🤖 AI & Machine Learning
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Ollama** | Run AI models locally | 🔴 Advanced | 8GB+ | ChatGPT alternative (local) |
| **Deepseek** | AI chat interface | 🔴 Advanced | 4GB+ | AI assistant |
| **OpenHands** | AI coding assistant | 🔴 Advanced | 8GB+ | AI pair programming |

### 🔍 Search & Discovery
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **SearXNG** | Privacy-focused search | 🟡 Intermediate | 512MB | Self-hosted search engine |

### 📡 Specialized Services
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Unifi-Controller** | Ubiquiti network controller | 🔴 Advanced | 1GB | Manage Unifi devices |
| **NUT-Server** | UPS monitoring | 🟡 Intermediate | 128MB | Monitor battery backup |
| **DynamicDNS** | Dynamic DNS updater | 🟡 Intermediate | 64MB | Update DNS automatically |
| **Komodo** | Server management | 🔴 Advanced | 512MB | Manage servers |
| **Zitadel** | Identity platform | 🔴 Advanced | 1GB | Enterprise IAM |

### 🏗️ Infrastructure & Orchestration
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Ansible** | Automation playbooks | 🔴 Advanced | N/A | Automate deployments |
| **Terraform** | Infrastructure as code | 🔴 Advanced | N/A | Provision infrastructure |
| **Kubernetes** | Container orchestration | 🔴 Advanced | 4GB+ | Advanced container management |
| **Docker-Swarm** | Docker clustering | 🔴 Advanced | 2GB+ | Multi-node Docker |

### 📚 Information & Guides
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Homelab-Buyer's-Guide** | Hardware recommendations | N/A | N/A | Choose hardware |
| **GPU_passthrough** | GPU passthrough guides | N/A | N/A | Pass GPU to VMs |
| **iGPU** | Intel GPU guides | N/A | N/A | Use integrated graphics |
| **LXC** | Container guides | N/A | N/A | Learn LXC |
| **MacWindows** | macOS/Windows VMs | N/A | N/A | Run different OSes |

### 🎨 Other Services
| Service | Description | Difficulty | RAM | Why You Need It |
|---------|-------------|------------|-----|-----------------|
| **Web-Servers** | Static site hosting | 🟢 Beginner | 128MB | Host websites |
| **UltimateVPS** | VPS setup | 🔴 Advanced | 1GB+ | Full VPS configuration |
| **Popup-Homelab** | Portable homelab | 🟡 Intermediate | Varies | Travel homelab setup |
| **StrixHaloToolboxes** | Strix Halo tools | 🟡 Intermediate | Varies | AMD hardware tools |
| **NordVPN-Wireguard** | NordVPN WireGuard | 🟡 Intermediate | 256MB | Use NordVPN with WG |
| **Torrent-VPN** | Torrents behind VPN | 🟡 Intermediate | 512MB | Download safely |

**Total Services: 90+** organized across 15+ categories!

> 💡 **Don't know where to start?** See the [Beginner's Journey](#-beginners-journey---your-first-30-days) below!

## 👶 Beginner's Journey - Your First 30 Days

**New to homelabs?** Follow this proven path from zero to hero!

### 🎯 Week 1: Foundation (Days 1-7)
**Goal:** Get your first services running

- [ ] **Day 1-2: Prepare Your System**
  - Install Docker & Docker Compose ([Guide](https://docs.docker.com/engine/install/))
  - Install Git
  - Clone this repository
  - Run `./scripts/init-homelab.sh`

- [ ] **Day 3-4: Deploy Traefik (Your First Service!)**
  - Navigate to `Traefikv3/`
  - Copy `.env.example` to `.env`
  - Edit domain and email
  - Run `docker-compose up -d`
  - Access Traefik dashboard at `traefik.yourdomain.com`
  - ✅ **Milestone:** You have a reverse proxy with automatic HTTPS!

- [ ] **Day 5-6: Deploy Pi-hole**
  - Navigate to `Pihole/`
  - Deploy with `docker-compose up -d`
  - Set DNS to Pi-hole IP
  - Watch ads disappear!
  - ✅ **Milestone:** Network-wide ad blocking active!

- [ ] **Day 7: Deploy Portainer**
  - Navigate to `Portainer/`
  - Deploy with `docker-compose up -d`
  - Access web UI
  - ✅ **Milestone:** You can manage Docker with a GUI!

**🎉 Week 1 Complete!** You now have the essential infrastructure running.

---

### 🔐 Week 2: Security (Days 8-14)
**Goal:** Secure your homelab

- [ ] **Day 8-10: Deploy Authelia**
  - Navigate to `Authelia/Authelia/`
  - Copy example configs
  - Generate secrets with `openssl rand -base64 64`
  - Configure users
  - Test 2FA login
  - ✅ **Milestone:** All services protected by 2FA!

- [ ] **Day 11-12: Deploy Vaultwarden**
  - Navigate to `Vaultwarden/`
  - Deploy password manager
  - Install browser extension
  - Migrate passwords
  - ✅ **Milestone:** All passwords in one secure place!

- [ ] **Day 13-14: Deploy WireGuard**
  - Navigate to `Wireguard/`
  - Deploy VPN server
  - Generate client configs
  - Test remote access
  - ✅ **Milestone:** Secure remote access to your homelab!

**🎉 Week 2 Complete!** Your homelab is now secure and accessible remotely.

---

### 🎬 Week 3: Choose Your Adventure (Days 15-21)
**Goal:** Deploy services based on YOUR interests

**Option A: Media Enthusiast**
- [ ] Deploy **Jellyfin** (Stream your movies/TV)
- [ ] Deploy **Immich** (Photo backup like Google Photos)
- [ ] Deploy **Paperless-ngx** (Organize documents)
- ✅ **Milestone:** Ditch cloud subscriptions!

**Option B: Productivity Focused**
- [ ] Deploy **Nextcloud** (Replace Dropbox/Google Drive)
- [ ] Deploy **Vikunja** (Task management)
- [ ] Deploy **Trilium** (Note-taking)
- ✅ **Milestone:** Own your data!

**Option C: Smart Home Builder**
- [ ] Deploy **Home-Assistant** (Control everything)
- [ ] Deploy **Mosquitto** (MQTT broker)
- [ ] Deploy **Zigbee2MQTT** (Connect devices)
- ✅ **Milestone:** Smart home without cloud dependency!

**Option D: Developer/Tinkerer**
- [ ] Deploy **Gitea** (Your own GitHub)
- [ ] Deploy **Code-Server** (VS Code in browser)
- [ ] Deploy **IT-Tools** (Developer utilities)
- ✅ **Milestone:** Complete dev environment!

Pick ONE option for week 3, try others later!

---

### 🚀 Week 4: Polish & Automation (Days 22-30)
**Goal:** Make your homelab maintainable

- [ ] **Day 22-24: Monitoring**
  - Deploy **Uptime Kuma** (Monitor uptime)
  - Deploy **Grafana-Monitoring** (Metrics)
  - Set up alerts
  - ✅ **Milestone:** Know when things break!

- [ ] **Day 25-26: Automation**
  - Deploy **Watchtower** (Auto-updates)
  - Deploy **Gotify** (Push notifications)
  - Configure update schedules
  - ✅ **Milestone:** Hands-off maintenance!

- [ ] **Day 27-28: Backup Strategy**
  - Set up **restic** or **rClone**
  - Configure automated backups
  - Test restore process
  - ✅ **Milestone:** Your data is safe!

- [ ] **Day 29-30: Documentation**
  - Document your setup
  - Create network diagram
  - Write disaster recovery plan
  - ✅ **Milestone:** Future you will thank you!

**🎉 30 Days Complete!** You now have a production-ready homelab!

---

## 🏗️ Network Architecture

Here's how your homelab will be structured:

```
┌─────────────────────────────────────────────────────────────────┐
│                          INTERNET                                │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                ┌───────────▼───────────┐
                │   Cloudflare CDN      │  (Optional - For external access)
                │   - DDoS Protection   │
                │   - SSL/TLS           │
                └───────────┬───────────┘
                            │
                ┌───────────▼───────────┐
                │   Your Router/ISP     │
                │   Port 80 & 443 →     │
                └───────────┬───────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
   ┌────▼────┐         ┌────▼────┐       ┌─────▼─────┐
   │ Pi-hole │         │ Traefik │       │ WireGuard │
   │   DNS   │         │  Proxy  │       │    VPN    │
   │ Ad Block│         │   SSL   │       │  Remote   │
   └─────────┘         └────┬────┘       └───────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
   ┌────▼────┐         ┌────▼────┐       ┌─────▼─────┐
   │Authelia │         │Services │       │ Services  │
   │  2FA    │◄────────┤Protected│       │ Public    │
   │  SSO    │         │ by Auth │       │No Auth Req│
   └─────────┘         └────┬────┘       └───────────┘
                            │
        ┌───────────────────┴───────────────────┐
        │                                       │
   ┌────▼──────┐  ┌──────────┐  ┌──────────┐  ┌▼──────────┐
   │ Jellyfin  │  │Nextcloud │  │ Gitea    │  │Vaultwarden│
   │  Media    │  │  Files   │  │   Git    │  │Passwords  │
   └───────────┘  └──────────┘  └──────────┘  └───────────┘
```

### 🔄 Traffic Flow Examples

**1. External User Accessing Jellyfin:**
```
Internet → Cloudflare → Router:443 → Traefik → Authelia (2FA) → Jellyfin
```

**2. Internal Network Browsing:**
```
Your Device → Pi-hole (DNS) → Router → Internet (Ads Blocked!)
```

**3. Remote Access via VPN:**
```
Phone (Away) → WireGuard VPN → Home Network → All Services
```

---

## ❓ Frequently Asked Questions

### 🤔 General Questions

**Q: Do I need a domain name?**  
**A:** Not required, but highly recommended.
- ✅ **With domain:** Proper SSL, external access, professional setup
- ⚠️ **Without domain:** Local access only, self-signed certificates, `service.local` addresses
- 💰 **Cost:** $10-15/year from Cloudflare, Namecheap, etc.

**Q: Can I run this on a Raspberry Pi?**  
**A:** Yes! Perfect for learning.
- ✅ **Good for:** Pi-hole, Traefik, Authelia, Vaultwarden, WireGuard, Watchtower
- ⚠️ **Avoid:** Plex (use Jellyfin), heavy databases, AI services, 4K transcoding
- 💡 **Tip:** Raspberry Pi 4 with 4GB+ RAM recommended

**Q: How much does this cost monthly?**  
**A:** Very affordable!
- **Electricity:** $5-30/month (depends on hardware)
- **Domain:** $10-15/year (optional)
- **Internet:** Use existing connection
- **Cloud services:** $0 (that's the point!)
- **Total:** ~$10-30/month, mostly electricity

**Q: Is this legal?**  
**A:** Absolutely! Self-hosting is 100% legal.
- ✅ **Legal:** Hosting your own services, media you own, personal use
- ⚠️ **Check laws:** VPN usage varies by country, content downloading regulations
- ❌ **Illegal:** Piracy, hosting copyrighted content without permission

**Q: Can I access my homelab from the internet?**  
**A:** Yes, but be smart about it!
1. **🟢 Best:** Use VPN (WireGuard/Headscale) - Most secure
2. **🟡 Good:** Reverse proxy + Cloudflare Tunnel - No port forwarding
3. **🟠 Okay:** Reverse proxy (Traefik) + Authelia - Requires port forwarding
4. **🔴 Never:** Direct port forwarding to services - Dangerous!

**Q: How much time does maintenance take?**  
**A:** With automation, very little!
- **Initial setup:** 2-4 hours per service (learning curve)
- **Weekly:** 0-30 minutes (check dashboards)
- **Monthly:** 1-2 hours (updates, backups verification)
- **With Watchtower:** Almost zero! (Auto-updates)

---

### 🐳 Docker vs Kubernetes

**Q: Should I use Docker Compose or Kubernetes?**  
**A:** For 95% of homelabs: **Docker Compose**

| Use Case | Docker Compose | Kubernetes |
|----------|----------------|------------|
| **Learning homelab** | ✅ Perfect | ❌ Overkill |
| **1-30 services** | ✅ Ideal | ❌ Too complex |
| **Single machine** | ✅ Simple | ⚠️ Possible but why? |
| **Multi-node cluster** | ⚠️ Limited | ✅ Designed for this |
| **High availability** | ❌ Not really | ✅ Built-in |
| **Learning for career** | 🟡 Basics | ✅ Industry standard |
| **Setup time** | 5 minutes | 2-4 hours |
| **Complexity** | 🟢 Low | 🔴 High |

**Start with Docker Compose. Move to K8s only if you:**
- Need high availability across multiple nodes
- Want to learn K8s for your career
- Have 3+ physical servers
- Enjoy pain complexity

---

### 🛠️ Ansible vs Terraform

**Q: What's the difference between Ansible and Terraform?**  
**A:** Different tools for different jobs!

| Tool | Purpose | Use When |
|------|---------|----------|
| **Ansible** | Configuration management | Configure existing servers, deploy apps, automate tasks |
| **Terraform** | Infrastructure provisioning | Create VMs, cloud resources, infrastructure as code |
| **Docker Compose** | Container orchestration | Run services on single machine |

**Example workflows:**
1. **Terraform** creates 3 VMs on Proxmox
2. **Ansible** installs Docker on those VMs
3. **Docker Compose** runs services on each VM

You don't need all three! Start with just Docker Compose.

---

### 🔧 Troubleshooting

**Q: My service won't start. What do I do?**  
**A:** Follow this checklist:

```
1. Check logs:
   docker-compose logs -f

2. Check if port is already in use:
   sudo netstat -tulpn | grep :PORT

3. Verify .env file exists:
   cat .env | grep -v "^#"

4. Check Docker is running:
   docker ps

5. Validate compose file:
   docker-compose config

6. Look for "CHANGE_ME" in configs:
   grep -r "CHANGE_ME" .

7. Check disk space:
   df -h

8. Restart everything:
   docker-compose down && docker-compose up -d
```

**Q: I forgot my Authelia password!**  
**A:** Edit `users_database.yml` and regenerate password hash:
```bash
docker run authelia/authelia:latest authelia hash-password 'yourpassword'
```

**Q: Traefik shows 404 error**  
**A:** Check:
- Service is running: `docker ps`
- Labels are correct in docker-compose.yml
- DNS points to Traefik host
- Traefik can reach the service network

**Q: Can't access services externally**  
**A:** Verify:
- Router ports 80 & 443 forwarded to Traefik
- Domain DNS points to your public IP
- Firewall allows incoming connections
- ISP doesn't block ports (some do!)

---

### 💾 Data & Backups

**Q: Where is my data stored?**  
**A:** In Docker volumes (usually `/var/lib/docker/volumes/`) or bind mounts specified in docker-compose.yml

**Q: How do I backup my homelab?**  
**A:** Three-tier strategy:
1. **Config files:** Git repository (this repo + your .env files encrypted)
2. **Docker volumes:** restic/rClone to cloud storage
3. **Important data:** Multiple locations (3-2-1 rule: 3 copies, 2 different media, 1 offsite)

**Q: Can I move services to another machine?**  
**A:** Yes!
1. Export docker volumes: `docker run --rm -v VOLUME:/data -v $(pwd):/backup alpine tar czf /backup/volume.tar.gz /data`
2. Copy docker-compose.yml and .env
3. Import on new machine: `docker run --rm -v VOLUME:/data -v $(pwd):/backup alpine tar xzf /backup/volume.tar.gz -C /`

---

## 📚 Learning Resources

New to these concepts? Here are the best resources:

### 🐳 Docker Basics
- [Official Docker Tutorial](https://docs.docker.com/get-started/) - Start here!
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NetworkChuck - Docker Tutorial](https://www.youtube.com/watch?v=eGz9DS-aIeY) - Great video intro

### 🌐 Networking Fundamentals
- [Networking Basics for Homelabs](https://www.youtube.com/watch?v=tWW5mxVsUH0) - NetworkChuck
- [DNS Explained](https://www.cloudflare.com/learning/dns/what-is-dns/)
- [How HTTPS Works](https://howhttps.works/) - Visual guide

### 🏠 Homelab Community
- [r/homelab](https://reddit.com/r/homelab) - Reddit community
- [r/selfhosted](https://reddit.com/r/selfhosted) - Self-hosting specific
- [Awesome-Selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted) - Huge service list
- [TechnoTim YouTube](https://www.youtube.com/c/TechnoTimLive) - Excellent homelab tutorials

### 📖 Advanced Topics
- [Ansible Documentation](https://docs.ansible.com/)
- [Terraform Tutorials](https://learn.hashicorp.com/terraform)
- [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)

---

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
