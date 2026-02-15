# Getting Started with Your Homelab

## What is a Homelab?

A homelab is your personal server environment where you:
- Run self-hosted services (instead of cloud services)
- Learn new technologies
- Have complete control over your data
- Replace expensive subscriptions

In simple terms: Your own mini data center at home.

## Prerequisites

Before starting, you need:

### Knowledge (Don't worry, you'll learn!)
- [ ] Can use a computer
- [ ] Comfortable typing commands
- [ ] Willing to learn from mistakes
- [ ] Can follow instructions

**That's it!** Everything else you'll learn along the way.

### Hardware (Use what you have!)
- [ ] Any computer (old laptop, desktop, Raspberry Pi)
- [ ] Internet connection
- [ ] 4GB+ RAM recommended
- [ ] 32GB+ storage

### Time Investment
- **Initial setup:** 2-4 hours
- **Learning curve:** 1-2 weeks
- **Maintenance:** 1-2 hours/month (can be automated)

## Your First Hour

### 1. Choose Your Hardware (5 minutes)

**Option A: Old Laptop/Desktop (Recommended for Easys)**
- Free (you already have it!)
- Enough power for learning
- Easy to set up
- Use it!

**Option B: Raspberry Pi**
- $50-150 purchase
- Low power consumption
- Limited performance
- Good for light services

**Option C: Buy/Build Server**
- $300-1500
- Best performance
- Do this later, after you know you like it

**Decision:** Start with what you have! You can always upgrade later.

### 2. Install Operating System (30 minutes)

**Recommended: Ubuntu Server 22.04 LTS**

Why?
- Free and open-source
- Most tutorials use it
- Long-term support
- Easy to use

**Installation:**
1. Download: [Ubuntu Server 22.04](https://ubuntu.com/download/server)
2. Create bootable USB: Use [Rufus](https://rufus.ie) (Windows) or [Etcher](https://www.balena.io/etcher/) (Mac/Linux)
3. Boot from USB
4. Follow installer:
 - Language: English
 - Keyboard: Your layout
 - Network: Automatic (DHCP)
 - Storage: Use entire disk
 - Profile: Create user account
 - SSH: Enable OpenSSH server <- Important!
 - Packages: Skip for now
5. Reboot and login

**Alternative: Use Docker Desktop (Windows/Mac)**
- Download: https://www.docker.com/products/docker-desktop
- Install and run
- Skip Ubuntu installation
- Slightly different commands, but works!

### 3. Install Docker (10 minutes)

SSH into your server:
```bash
ssh username@your-server-ip
```

Run this script (copies and pastes all at once):
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose-plugin -y

# Log out and back in
exit
```

Log back in:
```bash
ssh username@your-server-ip
```

Verify installation:
```bash
docker --version
docker compose version
```

### 4. Deploy Your First Service - Portainer (15 minutes)

Portainer = Web UI for managing Docker

```bash
# Create directory
mkdir -p ~/homelab/portainer
cd ~/homelab/portainer

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3'

services:
 portainer:
 image: portainer/portainer-ce:latest
 container_name: portainer
 restart: unless-stopped
 ports:
 - "9000:9000"
 volumes:
 - /var/run/docker.sock:/var/run/docker.sock
 - portainer_data:/data

volumes:
 portainer_data:
EOF

# Start Portainer
docker compose up -d

# Check it's running
docker ps
```

**Access Portainer:**
1. Open browser
2. Go to: `http://YOUR-SERVER-IP:9000`
3. Create admin account
4. Select "Docker" environment

** Congratulations!** You just deployed your first service!

## What You Just Learned

Let's break down what happened:

### docker-compose.yml
This file is a "recipe" for your service:
```yaml
services: # List of containers
 portainer: # Name of service
 image: ... # Which Docker image to use
 ports: # Which ports to expose
 volumes: # Where to store data
```

### docker compose up -d
This command:
- Reads the recipe (docker-compose.yml)
- Downloads the image (if needed)
- Creates and starts the container
- Runs it in background (`-d` = detached)

### Containers vs Images
- **Image:** Blueprint (like a recipe)
- **Container:** Running instance (like a cake from the recipe)

You can create many containers from one image!

## Your Next Steps

### Week 1: Foundation Services (Essential)

Deploy these three services:

1. [Traefik](Traefik-Setup) - Reverse proxy
 - Why: Makes all services accessible with nice URLs
 - Difficulty:  Easy
 - Time: 30 minutes

2. [Pi-hole](Pihole-Setup) - Ad blocker
 - Why: Block ads on entire network
 - Difficulty:  Easy
 - Time: 15 minutes

3. [Watchtower](Watchtower-Setup) - Auto-updates
 - Why: Keep containers updated automatically
 - Difficulty:  Easy
 - Time: 5 minutes

**After Week 1:** You have basic infrastructure!

### Week 2: Security Services (Important)

4. [Authelia](Authelia-Setup) - 2FA & SSO
 - Why: Protect all services with 2-factor authentication
 - Difficulty:  Medium
 - Time: 45 minutes

5. [Vaultwarden](Vaultwarden-Setup) - Password manager
 - Why: Secure password storage
 - Difficulty:  Easy
 - Time: 15 minutes

6. [WireGuard](WireGuard-Setup) - VPN
 - Why: Secure remote access
 - Difficulty:  Medium
 - Time: 30 minutes

**After Week 2:** Your homelab is secure!

### Week 3: Pick Your Adventure

Choose based on your interests:

** Media Enthusiast:**
- [Jellyfin](Jellyfin-Setup) - Stream your media
- [Immich](Immich-Setup) - Photo backup
- [Paperless-ngx](Paperless-Setup) - Document management

** Cloud Replacement:**
- [Nextcloud](Nextcloud-Setup) - File sync
- [Vikunja](Vikunja-Setup) - Task management
- [Trilium](Trilium-Setup) - Note-taking

** Smart Home:**
- [Home Assistant](Home-Assistant-Setup) - Smart home hub
- [Mosquitto](Mosquitto-Setup) - MQTT broker
- [Zigbee2MQTT](Zigbee2MQTT-Setup) - Zigbee bridge

** Developer:**
- [Gitea](Gitea-Setup) - Git hosting
- [Code-Server](Code-Server-Setup) - VS Code in browser
- [IT-Tools](IT-Tools-Setup) - Developer utilities

**After Week 3:** You have useful applications!

### Week 4: Polish & Monitoring

- [Uptime Kuma](Uptime-Kuma-Setup) - Monitor uptime
- [Grafana](Grafana-Setup) - Metrics & dashboards
- [Backup Strategy](Backup-Strategy) - Protect your data

**After Week 4:** Production-ready homelab! 

## Learning Resources

### Essential Reading
- [Docker Basics](Docker-Basics) - Understand containers
- [Networking 101](Networking-101) - IP addresses, DNS, ports
- [Linux Commands](Linux-Commands) - Terminal basics

### Video Tutorials
- [TechnoTim - Docker Tutorial](https://www.youtube.com/c/TechnoTimLive)
- [NetworkChuck - Homelab Series](https://www.youtube.com/channel/UC9x0AN7BWHpCDHSm9NiJFJQ)

### Communities
- [r/homelab](https://reddit.com/r/homelab) - General discussion
- [r/selfhosted](https://reddit.com/r/selfhosted) - Self-hosting specific
- [Discord Servers](Discord-Servers) - Real-time chat

## FAQ

### Do I need a domain name?
**Not required**, but recommended ($10/year).
- **Without:** Access via IP:port (e.g., 192.168.1.100:8096)
- **With:** Nice URLs (e.g., jellyfin.yourdomain.com)

### Can I use Windows/Mac?
**Yes!** Use Docker Desktop:
- Download: https://www.docker.com/products/docker-desktop
- Works great for learning
- Slightly different than Linux, but similar

### How much does electricity cost?
**Depends on hardware:**
- Raspberry Pi: $5-10/month
- Old laptop: $10-15/month
- Desktop: $15-25/month
- Server: $20-40/month

### Is this legal?
**Yes!** Self-hosting is 100% legal.
- Hosting your own services: Legal
- Using VPNs: Legal (in most countries)
- Piracy: Illegal (don't do it)

### What if something breaks?
**That's how you learn!**
- Check logs: `docker compose logs service-name`
- Google the error message
- Ask in r/homelab or r/selfhosted
- Worst case: Delete and recreate container

## Common Issues

### Can't access service from browser
**Check:**
```bash
# Is container running?
docker ps

# Check logs
docker compose logs service-name

# Check firewall
sudo ufw status
```

### Port already in use
**Find what's using it:**
```bash
sudo netstat -tulpn | grep :PORT
```

**Solution:** Stop the conflicting service or use different port

### Permission denied
**Add yourself to docker group:**
```bash
sudo usermod -aG docker $USER
# Log out and back in
```

### Container won't start
**Check logs:**
```bash
docker compose logs service-name
```

Common causes:
- Port already in use
- Missing .env file
- Wrong file permissions
- Typo in docker-compose.yml

## Success Checklist

After your first week, verify:

- [ ] Docker installed and working
- [ ] Portainer accessible and functional
- [ ] Can deploy services with `docker compose up -d`
- [ ] Can check logs with `docker compose logs`
- [ ] Understand basic Docker concepts
- [ ] Have deployed 3-5 services
- [ ] Services accessible from your network

## Next Steps

**Completed the basics?** Great! Now:

1. Read [First 30 Days](First-30-Days) guide
2. Browse [Service Catalog](Service-Catalog) for ideas
3. Join [r/homelab](https://reddit.com/r/homelab) community
4. Share your setup!
5. Help other beginners

**Want to dive deeper?**
- [Docker Basics](Docker-Basics) - Hard Docker concepts
- [Networking 101](Networking-101) - Network fundamentals
- [Kubernetes](Kubernetes-Deployment) - Next-level orchestration

---

## Feedback

Was this guide helpful? Found an error?
- Open a GitHub issue
- Submit a pull request
- Share your experience in r/homelab

---

**Ready for your next service?** 
 **[Deploy Traefik ->](Traefik-Setup)**

---

*Good luck on your homelab journey! Remember: Everyone started where you are. Take it one step at a time, and have fun! *
