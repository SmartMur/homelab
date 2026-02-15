# Hardware Requirements Calculator

Calculate exactly what hardware you need based on services you want to run.

## Quick Calculator

### Step 1: Count Your Services

Mark which services you want:

**Core Infrastructure (Required):**
- [ ] Traefik - 256MB RAM, 0.1 CPU
- [ ] Pi-hole - 512MB RAM, 0.2 CPU
- [ ] Portainer - 128MB RAM, 0.1 CPU
- [ ] Watchtower - 64MB RAM, 0.05 CPU

**Security (Recommended):**
- [ ] Authelia - 512MB RAM, 0.2 CPU
- [ ] Vaultwarden - 256MB RAM, 0.1 CPU
- [ ] WireGuard - 128MB RAM, 0.1 CPU

**Media Services:**
- [ ] Jellyfin (1080p) - 2GB RAM, 1 CPU
- [ ] Jellyfin (4K) - 4GB RAM, 2 CPU
- [ ] Plex - 2GB RAM, 1 CPU
- [ ] Sonarr - 512MB RAM, 0.2 CPU
- [ ] Radarr - 512MB RAM, 0.2 CPU
- [ ] Prowlarr - 256MB RAM, 0.1 CPU
- [ ] qBittorrent - 512MB RAM, 0.3 CPU
- [ ] Immich - 2GB RAM, 0.5 CPU

**Productivity:**
- [ ] Nextcloud - 1GB RAM, 0.5 CPU
- [ ] Gitea - 512MB RAM, 0.3 CPU
- [ ] Code-Server - 1GB RAM, 0.5 CPU
- [ ] Vikunja - 256MB RAM, 0.1 CPU
- [ ] Trilium - 256MB RAM, 0.1 CPU

**Home Automation:**
- [ ] Home Assistant - 1GB RAM, 0.5 CPU
- [ ] Mosquitto - 128MB RAM, 0.1 CPU
- [ ] Zigbee2MQTT - 256MB RAM, 0.1 CPU
- [ ] Frigate - 2GB RAM, 1 CPU (+ GPU recommended)

**Monitoring:**
- [ ] Uptime Kuma - 256MB RAM, 0.1 CPU
- [ ] Grafana - 512MB RAM, 0.3 CPU
- [ ] Prometheus - 512MB RAM, 0.3 CPU

**Communication:**
- [ ] Synapse - 1GB RAM, 0.5 CPU
- [ ] Jitsi - 2GB RAM, 1 CPU
- [ ] Gotify - 128MB RAM, 0.05 CPU

**Databases (if needed):**
- [ ] PostgreSQL - 512MB RAM, 0.3 CPU
- [ ] MariaDB - 512MB RAM, 0.3 CPU
- [ ] Redis - 256MB RAM, 0.1 CPU
- [ ] MongoDB - 1GB RAM, 0.5 CPU

### Step 2: Calculate Requirements

Add up your selections:

```
Total RAM needed = Sum of all RAM + 20% overhead
Total CPU needed = Sum of all CPU cores
Total Storage = 50GB base + (media storage) + (backup storage)
```

**Example calculation:**

```
Services selected:
- Core Infrastructure: 960MB, 0.45 CPU
- Authelia: 512MB, 0.2 CPU
- Vaultwarden: 256MB, 0.1 CPU
- Jellyfin (1080p): 2GB, 1 CPU
- Nextcloud: 1GB, 0.5 CPU
- PostgreSQL: 512MB, 0.3 CPU

Total: 5.24GB RAM, 2.55 CPU cores

With 20% overhead:
- RAM: 6.3GB → Recommend 8GB
- CPU: 2.55 cores → Recommend 4 cores
- Storage: 50GB (system) + 500GB (media) = 550GB → Recommend 1TB
```

---

## Hardware Tiers by Service Count

### Tier 1: Starter (5-10 services)

**Recommended Hardware:**
```
CPU: 4 cores (Intel i3-10100, AMD Ryzen 3 3100)
RAM: 8GB DDR4
Storage: 256GB SSD
Network: 1Gb ethernet
Form Factor: Mini PC, NUC, or old laptop

Examples:
- Intel NUC 10 i3
- Lenovo ThinkCentre Tiny
- HP EliteDesk 800 G3 Mini
- Old gaming laptop

Cost: $150-300 used, $400-500 new
Power: 15-25W
Monthly electricity: $3-5
```

**Example Services:**
- Traefik, Pi-hole, Authelia
- Vaultwarden, Portainer, Watchtower
- Jellyfin (1080p), Nextcloud
- Uptime Kuma, Gitea

**Performance:**
- 1-2 simultaneous Jellyfin streams (1080p)
- Light web browsing via Nextcloud
- 5-10 users total

---

### Tier 2: Standard (15-25 services)

**Recommended Hardware:**
```
CPU: 6 cores (Intel i5-12400, AMD Ryzen 5 5600)
RAM: 16GB DDR4
Storage: 512GB NVMe SSD + 2TB HDD
Network: 1Gb ethernet
Form Factor: Mini PC or small tower

Examples:
- Intel NUC 11/12 i5
- Custom build (mini ITX)
- Dell OptiPlex 7050 SFF
- HP ProDesk 600 G4

Cost: $400-700 used, $800-1200 new
Power: 30-50W
Monthly electricity: $6-10
```

**Example Services:**
- All Tier 1 services +
- Jellyfin (4K), Sonarr, Radarr, Prowlarr
- Home Assistant, Mosquitto
- Grafana, Prometheus
- Multiple databases

**Performance:**
- 2-4 simultaneous streams (1080p/4K)
- Hardware transcoding capable
- 10-20 users

---

### Tier 3: Advanced (30-50 services)

**Recommended Hardware:**
```
CPU: 8 cores (Intel i7-12700, AMD Ryzen 7 5800X)
RAM: 32GB DDR4
Storage: 1TB NVMe SSD + 4TB HDD
Network: 2.5Gb or 10Gb ethernet
GPU: Intel iGPU or NVIDIA GPU (optional)
Form Factor: Tower or rack mount

Examples:
- Custom build
- Dell PowerEdge T340
- HP ProLiant ML30 Gen10
- Supermicro workstation

Cost: $800-1500 used, $1500-2500 new
Power: 60-100W
Monthly electricity: $12-20
```

**Example Services:**
- All Tier 2 services +
- Multiple media services
- Full automation stack (*arr apps)
- Kubernetes cluster (single node)
- Multiple VMs via Proxmox
- Full monitoring stack

**Performance:**
- 5-8 simultaneous streams (4K)
- Multiple concurrent users
- VM hosting capability
- 20-50 users

---

### Tier 4: Enthusiast/Production (50+ services)

**Recommended Hardware:**
```
CPU: 12+ cores (Intel i9, AMD Ryzen 9, Xeon)
RAM: 64GB+ DDR4/DDR5
Storage: 2TB NVMe SSD + 10TB+ HDD array
Network: 10Gb ethernet
GPU: Dedicated GPU for transcoding
Form Factor: Rack mount or high-end tower

Examples:
- Dell PowerEdge R730
- HP ProLiant DL380 Gen10
- Supermicro server
- Custom dual-CPU build

Cost: $1500-3000 used, $3000-5000 new
Power: 100-200W
Monthly electricity: $20-40
```

**Example Services:**
- Everything
- Kubernetes cluster (multi-node)
- High availability setups
- Multiple isolated environments
- Enterprise-grade monitoring
- Extensive automation

**Performance:**
- 10+ simultaneous 4K streams
- Unlimited users
- Production workloads
- Development environments

---

## Storage Calculator

### System Storage

```
Base OS: 20GB
Docker images: 10-30GB
Configs: 1-5GB
Logs: 5-10GB
Buffer: 20GB

Minimum: 50GB
Recommended: 100GB
Optimal: 256GB SSD
```

### Service Storage

```
Per Service Average:
- Small (Traefik, Pi-hole): 100MB-500MB
- Medium (Nextcloud, Gitea): 1-5GB
- Large (Jellyfin, databases): 5-50GB
- Media libraries: Varies widely

Example for 20 services:
- 10 small: 5GB
- 7 medium: 20GB
- 3 large: 30GB
Total: 55GB

Recommended: 100-200GB for apps
```

### Media Storage

```
Movies (1080p): ~3-8GB each
Movies (4K): ~20-60GB each
TV episodes (1080p): ~500MB-2GB each
TV episodes (4K): ~3-10GB each
Music (FLAC): ~30-50MB per song
Photos (RAW): ~25-50MB each

Example library:
- 100 movies (1080p): 500GB
- 50 TV shows (1080p): 500GB
- 10,000 songs: 300GB
- 5,000 photos: 125GB
Total: 1.4TB

Recommended: 2-4TB for media
Add 50% for growth: 3-6TB
```

---

## Power Consumption Calculator

### Average Power Draw

```
Component Power Usage:
- CPU (idle): 10-20W
- CPU (load): 30-100W
- RAM (per 8GB): 3-5W
- SSD (per drive): 2-5W
- HDD (per drive): 5-10W
- Network card: 2-5W
- Motherboard: 20-30W

Example System:
- i5-12400 (35W average)
- 16GB RAM (5W)
- 2x SSD (6W)
- 1x HDD (8W)
- Motherboard (25W)
Total: ~80W

Daily: 80W × 24h = 1.92 kWh
Monthly: 1.92 × 30 = 57.6 kWh
Yearly: 57.6 × 12 = 691 kWh

At $0.15/kWh:
- Daily: $0.29
- Monthly: $8.64
- Yearly: $103.65
```

### Power by Tier

```
Tier 1 (Starter):
- Average: 20W
- Monthly cost: $3-5

Tier 2 (Standard):
- Average: 40W
- Monthly cost: $6-10

Tier 3 (Advanced):
- Average: 80W
- Monthly cost: $12-20

Tier 4 (Enthusiast):
- Average: 150W
- Monthly cost: $23-35
```

---

## Budget Planning

### Total Cost of Ownership (3 years)

**Tier 1 Setup:**
```
Hardware: $300
Electricity (3yr): $180
Domain (3yr): $45
Total: $525

Per month: $14.58
```

**Tier 2 Setup:**
```
Hardware: $800
Electricity (3yr): $360
Domain (3yr): $45
UPS: $100
Total: $1,305

Per month: $36.25
```

**Tier 3 Setup:**
```
Hardware: $1,500
Electricity (3yr): $720
Domain (3yr): $45
UPS: $200
Network gear: $300
Total: $2,765

Per month: $76.81
```

**Compare to cloud services:**
```
Cloud alternatives:
- Google Workspace: $12/mo = $432/3yr
- Dropbox: $12/mo = $432/3yr
- Netflix: $15/mo = $540/3yr
- Plex Pass: $5/mo = $180/3yr
- VPN: $5/mo = $180/3yr
- Password manager: $3/mo = $108/3yr
Total: $1,872/3yr

Tier 2 homelab: $1,305/3yr
Savings: $567 over 3 years
Plus: You own the hardware!
```

---

## Upgrade Path

### Starting Small

```
Year 1: Buy Tier 1 ($300)
- Learn the basics
- Run 5-10 services
- See if you like it

Year 2: Upgrade to Tier 2 ($500 more)
- Reuse some parts
- Add more RAM
- Better CPU
- More storage

Year 3: Tier 3 or keep Tier 2
- Evaluate actual needs
- Upgrade if running out of resources
- Or build second server
```

---

## Quick Decision Matrix

**Choose your tier:**

```
I want to:
[ ] Learn and experiment → Tier 1
[ ] Replace some cloud services → Tier 2
[ ] Replace most cloud services → Tier 2-3
[ ] Run everything + VMs → Tier 3
[ ] Production workloads → Tier 3-4
[ ] Kubernetes cluster → Tier 3-4
[ ] High availability → Tier 4

Budget:
[ ] Under $500 → Tier 1
[ ] $500-1000 → Tier 2
[ ] $1000-2000 → Tier 3
[ ] $2000+ → Tier 4

Technical skill:
[ ] Beginner → Tier 1-2
[ ] Intermediate → Tier 2-3
[ ] Advanced → Tier 3-4
```

---

## Real-World Examples

### Example 1: Budget Media Server

```
Goal: Replace Netflix, store family photos
Services: Jellyfin, Immich, Pi-hole, Traefik
Hardware: Old laptop (i5-8250U, 8GB RAM, 256GB SSD)
Added: 2TB external HDD
Cost: $0 (reused hardware) + $60 (HDD)
Power: 25W = $5/month
```

### Example 2: Home Office

```
Goal: Nextcloud, Gitea, development
Services: Nextcloud, Gitea, Code-Server, Portainer
Hardware: Intel NUC 11 i5 (16GB, 512GB SSD)
Cost: $600
Power: 35W = $7/month
```

### Example 3: Full Stack

```
Goal: Everything - media, automation, dev
Services: 30+ services
Hardware: Custom build (Ryzen 5600, 32GB, 1TB SSD + 4TB HDD)
Cost: $1,200
Power: 60W = $12/month
```

---

## Need Help Deciding?

Answer these questions:

1. How many people will use it? _____
2. Do you need 4K streaming? Yes / No
3. How much media do you have? _____ TB
4. Will you run VMs? Yes / No
5. Budget for hardware? $ _____
6. Monthly electricity budget? $ _____

**Results:**
- 1-3 people, no 4K, <2TB, no VMs, <$500 → Tier 1
- 3-5 people, some 4K, 2-5TB, maybe VMs, $500-1000 → Tier 2
- 5+ people, 4K, 5+ TB, yes VMs, $1000+ → Tier 3-4
