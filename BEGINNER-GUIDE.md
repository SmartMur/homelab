# 🎓 Complete Beginner's Guide to Self-Hosting

> **Welcome!** This guide assumes you have ZERO experience with self-hosting, Docker, or homelabs. We'll start from the absolute basics and build up to a fully functional homelab.

---

## 📚 Table of Contents

1. [What is a Homelab?](#what-is-a-homelab)
2. [Why Self-Host?](#why-self-host)
3. [Prerequisites](#prerequisites)
4. [Understanding the Basics](#understanding-the-basics)
5. [Choosing Your Hardware](#choosing-your-hardware)
6. [Installing Docker](#installing-docker)
7. [Your First Service](#your-first-service)
8. [Week-by-Week Journey](#week-by-week-journey)
9. [Common Mistakes to Avoid](#common-mistakes-to-avoid)
10. [Getting Help](#getting-help)

---

## 🏠 What is a Homelab?

A **homelab** is a personal environment where you run services on your own hardware instead of relying on cloud providers like Google, Microsoft, or Amazon.

**Think of it like this:**
- Instead of paying Google for Drive → You run Nextcloud at home
- Instead of using Google Photos → You run Immich on your own server
- Instead of Netflix (but for your own media) → You run Jellyfin/Plex

**Your homelab is:**
- 🏠 A computer/server running 24/7 at your home
- 📦 Multiple "services" (apps) running in containers
- 🌐 Accessible from your devices (phone, laptop, TV)
- 🔒 Under YOUR control, not Big Tech

---

## 🎯 Why Self-Host?

### ✅ Advantages

1. **Privacy** - Your data stays on YOUR hardware
2. **Control** - You decide what runs and how
3. **Learning** - Gain valuable tech skills
4. **Cost Savings** - Replace multiple subscriptions
5. **Customization** - Configure everything exactly how you want
6. **Fun** - It's genuinely enjoyable to build!

### ⚠️ Trade-offs

1. **Time Investment** - Initial setup takes time (worth it!)
2. **Electricity Costs** - ~$10-30/month depending on hardware
3. **Maintenance** - Updates, monitoring (can be automated)
4. **Internet Dependency** - Need good home internet
5. **Learning Curve** - New concepts to learn (we'll help!)

---

## ✅ Prerequisites

### What You NEED to Know (Before Starting)

#### 🟢 Absolute Basics (Must Have)
- [ ] **Use a computer** - Navigate files, install programs
- [ ] **Use a web browser** - Click links, enter URLs
- [ ] **Basic typing** - Can edit text files
- [ ] **Follow instructions** - Read and execute steps in order

#### 🟡 Helpful but Not Required (Can Learn Along the Way)
- [ ] **Command line basics** - Ever used Terminal/CMD?
- [ ] **What an IP address is** - Like 192.168.1.100
- [ ] **What a port is** - Like :80 or :443
- [ ] **Copy/paste code** - Into terminal or config files

#### ❌ You DON'T Need to Know (Yet!)
- ❌ Programming/coding
- ❌ Linux system administration
- ❌ Networking protocols
- ❌ Docker/containers (you'll learn!)

**If you can use a computer and follow directions, you can do this!**

---

## 🧠 Understanding the Basics

Before we start, let's understand the key concepts:

### 🐳 What is Docker?

**Simple explanation:**
- Docker is like a "shipping container" for apps
- Each app runs in its own isolated "container"
- Containers include everything the app needs to run
- You can start/stop/remove containers easily

**Why it matters:**
- Install complex apps in seconds (not hours)
- Each app is isolated (can't break each other)
- Easy to backup, move, or delete

**Analogy:**
- **Without Docker:** Installing 10 apps = 10 different installation guides, dependencies, conflicts
- **With Docker:** Installing 10 apps = Copy 10 folders, run `docker-compose up`, done!

### 🌐 What is a Reverse Proxy? (Traefik)

**Simple explanation:**
- One entrance for all your services
- Routes traffic: "jellyfin.yourdomain.com" → Jellyfin, "nextcloud.yourdomain.com" → Nextcloud
- Handles HTTPS/SSL automatically
- Like a receptionist directing visitors to the right office

**Why you need it:**
- Access services with nice URLs (not IP:port)
- Automatic HTTPS certificates
- One place to manage access

### 🔒 What is 2FA/SSO? (Authelia)

**Simple explanation:**
- **2FA** (Two-Factor Authentication) = Username + Password + Phone Code
- **SSO** (Single Sign-On) = Log in once, access everything
- Protects ALL your services with one login

**Why you need it:**
- Even if password leaks, attacker needs your phone
- Don't remember 20 different passwords
- Security without hassle

### 🏠 What is DNS? (Pi-hole)

**Simple explanation:**
- DNS translates names (google.com) to numbers (142.250.80.46)
- Pi-hole = DNS server that blocks ads/trackers
- Every device on your network uses it

**Why you need it:**
- Block ads on ALL devices (even apps!)
- Block tracking/telemetry
- Faster internet (blocks = less data)

---

## 💻 Choosing Your Hardware

### 🤔 What Can I Use?

You have several options:

#### Option 1: Old Laptop/Desktop (🟢 Best for Beginners)
**Pros:**
- ✅ You probably already have one
- ✅ Free to start
- ✅ Decent performance
- ✅ Built-in battery backup (laptop)

**Cons:**
- ⚠️ Uses more power than dedicated hardware
- ⚠️ Takes up space
- ⚠️ May be noisy

**Perfect for:** Testing, learning, first 6 months

#### Option 2: Raspberry Pi 4/5 (🟢 Great for Learning)
**Pros:**
- ✅ Very low power ($5-10/month electricity)
- ✅ Silent operation
- ✅ Small footprint
- ✅ Affordable ($50-100)

**Cons:**
- ⚠️ Limited performance (ARM CPU)
- ⚠️ 8GB RAM max
- ⚠️ No x86 support (some apps won't work)

**Perfect for:** Pi-hole, Traefik, lightweight services

#### Option 3: Mini PC / Intel NUC (🟡 Recommended)
**Pros:**
- ✅ Low power consumption
- ✅ Silent or near-silent
- ✅ Small form factor
- ✅ Good performance
- ✅ x86 compatibility

**Cons:**
- ⚠️ Costs $300-600
- ⚠️ Limited upgradeability

**Perfect for:** Serious homelab, 20+ services

#### Option 4: Custom Server Build (🔴 Advanced)
**Pros:**
- ✅ Maximum performance
- ✅ Highly upgradable
- ✅ Can add GPUs, lots of storage

**Cons:**
- ⚠️ Expensive ($1000+)
- ⚠️ High power consumption
- ⚠️ Can be noisy
- ⚠️ Takes up space

**Perfect for:** Power users, multiple VMs, media transcoding

### 📋 Minimum Recommended Specs

For a good beginner experience:

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **CPU** | 2 cores | 4 cores |
| **RAM** | 4GB | 8-16GB |
| **Storage** | 32GB SSD | 128GB SSD + HDD for media |
| **Network** | 100Mbps ethernet | Gigabit ethernet |
| **Power** | N/A | UPS backup (optional) |

### 💰 Budget Recommendations

**$0 - Use what you have:**
- Old laptop gathering dust
- Desktop you're not using
- **Cost:** Free!

**$50-150 - Entry Level:**
- Raspberry Pi 4 (8GB) + Case + Power Supply + SD Card
- **Services:** 5-10 lightweight services
- **Cost:** ~$100-150

**$300-600 - Sweet Spot:**
- Used/New Mini PC (e.g., Dell Optiplex Micro, Lenovo ThinkCentre Tiny, Intel NUC)
- i5/Ryzen 5, 16GB RAM, 256GB SSD
- **Services:** 20-30 services comfortably
- **Cost:** ~$300-600

**$800-1500 - Enthusiast:**
- Custom build or high-end Mini PC
- i7/Ryzen 7, 32-64GB RAM, NVMe SSD + HDD
- **Services:** Unlimited
- **Cost:** ~$800-1500

### 🎯 My Recommendation for Beginners

**Start with what you have!** 

1. Use an old laptop/desktop for 1-3 months
2. Learn the basics, see if you enjoy it
3. If you love it, upgrade to a Mini PC
4. If you go all-in, build a custom server

**Don't spend money until you know you'll stick with it!**

---

## 🐳 Installing Docker

Docker is the foundation of your homelab. Let's install it!

### For Ubuntu/Debian Linux

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (no need for sudo)
sudo usermod -aG docker $USER

# Log out and back in, then test
docker --version
docker compose version
```

### For Windows (Docker Desktop)

1. Download Docker Desktop: https://www.docker.com/products/docker-desktop
2. Install and restart
3. Open Docker Desktop
4. Enable WSL 2 backend if prompted
5. Test in PowerShell: `docker --version`

### For macOS (Docker Desktop)

1. Download Docker Desktop: https://www.docker.com/products/docker-desktop
2. Drag to Applications
3. Open Docker Desktop
4. Test in Terminal: `docker --version`

### ✅ Verify Installation

Run these commands:

```bash
# Check Docker version
docker --version
# Should show: Docker version 24.x.x

# Check Docker Compose version
docker compose version
# Should show: Docker Compose version v2.x.x

# Test Docker works
docker run hello-world
# Should download and run a test container
```

If all three work, you're ready! 🎉

---

## 🚀 Your First Service: Portainer

Let's deploy your first service! We'll use **Portainer** - a web UI for managing Docker.

### Why Portainer First?

- ✅ Simple to set up
- ✅ Gives you a visual interface
- ✅ Helps you understand Docker
- ✅ Makes managing other services easier

### Step 1: Create a Directory

```bash
# Create directory for Portainer
mkdir -p ~/homelab/portainer
cd ~/homelab/portainer
```

### Step 2: Create docker-compose.yml

```bash
# Create the file
nano docker-compose.yml
```

Paste this content:

```yaml
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
```

Save with `Ctrl+O`, `Enter`, then exit with `Ctrl+X`

### Step 3: Start Portainer

```bash
# Start the container
docker compose up -d

# Check it's running
docker ps
```

You should see portainer in the list!

### Step 4: Access Portainer

1. Open browser
2. Go to: `http://YOUR-SERVER-IP:9000`
3. Create admin account (username + password)
4. Select "Docker" environment
5. Click "Connect"

**🎉 Congratulations!** You just deployed your first self-hosted service!

### Understanding What You Did

- **docker-compose.yml** = Recipe for the service
- **docker compose up -d** = "Start this service in background"
- **Port 9000** = How you access it (IP:9000)
- **Volumes** = Where data is stored (persists after restarts)

---

## 📅 Week-by-Week Journey

Now that you understand the basics, follow this proven 30-day path:

### 🎯 Week 1: Foundation (Days 1-7)

#### Day 1-2: Preparation
- [ ] Choose your hardware
- [ ] Install OS (Ubuntu Server 22.04 recommended)
- [ ] Install Docker & Docker Compose
- [ ] Deploy Portainer
- [ ] Get comfortable with Portainer UI

#### Day 3-4: First Real Service - Traefik
**What:** Reverse proxy with automatic HTTPS  
**Why:** Makes all future services accessible with nice URLs

```bash
cd ~/homelab
git clone https://github.com/SmartMur/homelab.git
cd homelab/Traefikv3
cp .env.example .env
nano .env  # Edit YOUR_DOMAIN and EMAIL
docker compose up -d
```

**Success Check:**
- Access Traefik dashboard
- See automatic HTTPS certificate

#### Day 5-6: Network-Wide Ad Blocking - Pi-hole
**What:** DNS server that blocks ads  
**Why:** Block ads on ALL devices

```bash
cd ~/homelab/homelab/Pihole
docker compose up -d
```

**Success Check:**
- Access Pi-hole web UI
- Set router DNS to Pi-hole IP
- Ads blocked on phone/laptop

#### Day 7: Review & Troubleshoot
- [ ] All 3 services running?
- [ ] Can access via browser?
- [ ] Understand what each does?
- [ ] Read logs if something broke

**🎉 Week 1 Milestone:** You have a functioning reverse proxy, Docker GUI, and network ad blocker!

---

### 🔐 Week 2: Security (Days 8-14)

#### Day 8-10: Two-Factor Authentication - Authelia
**What:** Add 2FA to all services  
**Why:** Security without managing 20 passwords

```bash
cd ~/homelab/homelab/Authelia/Authelia
cp .env.example .env
cp configuration.yml.example configuration.yml
cp users_database.yml.example users_database.yml

# Generate secrets
openssl rand -base64 64  # Copy this for JWT secret
openssl rand -base64 64  # Copy this for session secret

nano .env  # Add secrets
nano users_database.yml  # Add your username

docker compose up -d
```

**Success Check:**
- Access Authelia UI
- Scan QR code with authenticator app
- Test 2FA login

#### Day 11-12: Password Manager - Vaultwarden
**What:** Self-hosted Bitwarden  
**Why:** Never forget a password again

```bash
cd ~/homelab/homelab/Vaultwarden
docker compose up -d
```

**Success Check:**
- Create account
- Install browser extension
- Add first password

#### Day 13-14: VPN Access - WireGuard
**What:** Secure remote access  
**Why:** Access homelab from anywhere

```bash
cd ~/homelab/homelab/Wireguard
docker compose up -d
```

**Success Check:**
- Generate client config
- Connect from phone
- Access services remotely

**🎉 Week 2 Milestone:** Your homelab is secure and accessible from anywhere!

---

### 🎬 Week 3: Choose Your Path (Days 15-21)

Pick ONE based on your interests:

#### Path A: Media Server
Deploy: Jellyfin → Immich → Paperless-ngx

#### Path B: Productivity Suite  
Deploy: Nextcloud → Vikunja → Trilium

#### Path C: Smart Home
Deploy: Home-Assistant → Mosquitto → Zigbee2MQTT

#### Path D: Developer Environment
Deploy: Gitea → Code-Server → IT-Tools

**Focus on ONE path. Try others later!**

---

### 🚀 Week 4: Polish (Days 22-30)

#### Day 22-24: Monitoring
Deploy: Uptime Kuma + Grafana

#### Day 25-26: Automation
Deploy: Watchtower + Gotify

#### Day 27-28: Backups
Set up: restic or rClone

#### Day 29-30: Documentation
- Document your setup
- Create recovery plan
- Celebrate! 🎉

**🎉 30-Day Milestone:** Production-ready homelab!

---

## ❌ Common Mistakes to Avoid

### 1. Starting Too Big
**Mistake:** Trying to deploy 20 services in week 1  
**Solution:** Start with 3-5 core services, add more slowly

### 2. Ignoring Backups
**Mistake:** No backup strategy until data loss  
**Solution:** Set up backups by week 3, test restores

### 3. Weak Passwords
**Mistake:** Using "password123" or same password everywhere  
**Solution:** Use Vaultwarden to generate strong, unique passwords

### 4. Exposing Everything to Internet
**Mistake:** Port forwarding everything without VPN/2FA  
**Solution:** Use VPN or Authelia before exposing services

### 5. Not Reading Logs
**Mistake:** Service fails, give up without checking logs  
**Solution:** Always check: `docker compose logs -f`

### 6. Skipping .env Files
**Mistake:** Hardcoding secrets in docker-compose.yml  
**Solution:** Always use .env files for sensitive data

### 7. No Documentation
**Mistake:** Forgetting how you set things up  
**Solution:** Document as you go, future you will thank you

### 8. Updating Everything at Once
**Mistake:** Updating 20 services simultaneously, everything breaks  
**Solution:** Update one service at a time, test before next

### 9. No Testing Before Production
**Mistake:** Deploying untested configs to production  
**Solution:** Test in dev first, then promote to production

### 10. Giving Up Too Early
**Mistake:** First error = quit  
**Solution:** Errors are learning opportunities! Google, ask community, persevere

---

## 🆘 Getting Help

### 📖 Documentation

1. **This Repository**
   - README.md - Overview and catalog
   - BEGINNER-GUIDE.md - This guide
   - Service-specific READMEs - Detailed guides

2. **Official Documentation**
   - Docker: https://docs.docker.com
   - Each service has its own docs

### 💬 Communities

1. **Reddit**
   - r/homelab - General homelab discussion
   - r/selfhosted - Self-hosting specific
   - r/docker - Docker questions

2. **Discord Servers**
   - Search for "homelab discord"
   - Most projects have official servers

3. **Forums**
   - Serverfault, Superuser
   - Project-specific forums

### 🎥 YouTube Channels

1. **TechnoTim** - Excellent homelab tutorials
2. **NetworkChuck** - Beginner-friendly networking
3. **Awesome Open Source** - Self-hosted app reviews
4. **DB Tech** - Docker & homelab guides

### 🔍 How to Ask for Help

**❌ Bad Question:**
```
"Jellyfin doesn't work help"
```

**✅ Good Question:**
```
"I'm trying to deploy Jellyfin on Ubuntu 22.04 with Docker Compose.

When I run `docker compose up -d`, the container starts but I get a 502 error when accessing http://IP:8096.

Logs show: [error here]

I've checked:
- Container is running (docker ps)
- Ports are correct in docker-compose.yml
- Firewall is disabled for testing

What else should I check?"
```

**Include:**
- What you're trying to do
- What you've already tried
- Error messages / logs
- Your setup (OS, Docker version)

---

## 🎯 Next Steps

1. **Complete the 30-Day Journey**
   - Don't rush
   - Learn each service
   - Document everything

2. **Join the Community**
   - Share your setup on r/homelab
   - Help others once you learn
   - Show off your dashboard!

3. **Keep Learning**
   - Try new services
   - Optimize your setup
   - Consider Kubernetes (later!)

4. **Share Your Knowledge**
   - Write a blog post
   - Make YouTube video
   - Help the next beginner

---

## 🎉 Welcome to the Homelab Community!

You're now part of a community of thousands of people who:
- Value privacy and ownership
- Love learning and tinkering
- Share knowledge freely
- Support each other

**Remember:**
- Everyone was a beginner once
- Mistakes are how you learn
- The community is here to help
- Have fun!

**Now go build something awesome! 🚀**

---

## 📚 Additional Resources

- [Main README](README.md) - Service catalog and quick start
- [Security Guide](SECURITY.md) - Best practices
- [Service-Specific Guides](.) - Detailed service READMEs
- [Troubleshooting](README.md#troubleshooting) - Common issues

---

*Questions? Issues? Contributions?*  
Open an issue on GitHub or join the discussion in r/homelab!
