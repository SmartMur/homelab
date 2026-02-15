# Showcase: Minimal Homelab

**User:** Beginner  
**Hardware:** Raspberry Pi 4 (4GB)  
**Services:** 6 core services  
**Purpose:** Learning & basic self-hosting  

## Hardware Specs

```
Device: Raspberry Pi 4 Model B
CPU: Quad-core ARM Cortex-A72 @ 1.5GHz
RAM: 4GB LPDDR4
Storage: 128GB microSD card
Network: Gigabit Ethernet
Power: Official 15W USB-C adapter
Case: Flirc aluminum case (passive cooling)

Total cost: $120
Power usage: 8W average
Monthly electricity: ~$2
```

## Services Running

```
1. Traefik - Reverse proxy
2. Pi-hole - DNS & ad blocking
3. Vaultwarden - Password manager
4. Portainer - Docker management
5. Watchtower - Auto-updates
6. Uptime Kuma - Monitoring

Total RAM usage: 2.8GB / 4GB
CPU load: 15-25% average
Storage used: 12GB / 128GB
```

## Network Diagram

```
Internet
   │
Router (192.168.1.1)
   │
   ├─> Pi-hole :53 (DNS)
   │
   └─> Raspberry Pi (192.168.1.100)
       │
       ├─> Traefik :80,:443
       │   ├─> Vaultwarden
       │   ├─> Portainer
       │   └─> Uptime Kuma
       │
       └─> Watchtower (background)
```

## Deployment Process

```bash
# 1. Flash Raspberry Pi OS Lite (64-bit)
# 2. SSH into Pi
ssh pi@192.168.1.100

# 3. Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker pi

# 4. Clone repo
git clone https://github.com/SmartMur/homelab.git
cd homelab

# 5. Deploy core services
./scripts/deploy-core.sh

# Total time: 20 minutes
```

## Why This Setup Works

**Pros:**
- Very low power consumption ($2/month)
- Silent operation (passive cooling)
- Teaches Docker basics
- Handles essential services
- Room to add more services

**Cons:**
- ARM architecture (some images don't support)
- Limited to lighter services
- SD card can be slow
- No hardware transcoding for media

## What I Use It For

- Password management (Vaultwarden)
- Network-wide ad blocking (Pi-hole)
- Learning Docker
- Monitoring uptime of external services
- Keeping Docker containers updated

## Lessons Learned

1. SD card speed matters - use A2 rated cards
2. Passive cooling is enough for this load
3. ARM compatibility - check before deploying
4. Perfect for learning without big investment
5. Can run 24/7 without worrying about power

## Future Plans

Keep as-is for core services, add a second device for:
- Media server (needs more power)
- Home Assistant
- More resource-intensive apps

## Would I Recommend This?

**Yes if:**
- You're learning
- You want low power usage
- You need basic services only
- You have <$150 budget

**No if:**
- You want media streaming
- You need many services
- You want 4K transcoding
- You need high performance

## Stats After 6 Months

```
Uptime: 99.2%
Containers restarts: 3 (all intentional updates)
SD card failures: 0
Power outages handled: 2 (graceful shutdown via UPS)
Services added: 2 (Homepage dashboard, Gotify)
Total cost: $150 (hardware + UPS)
```

Absolutely worth it for learning!
