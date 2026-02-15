# Showcase: Complete Media Server

**User:** Intermediate  
**Hardware:** Intel NUC 11 i5  
**Services:** 15 services  
**Purpose:** Replace all streaming subscriptions  

## Hardware Specs

```
Device: Intel NUC 11 Performance (NUC11PAHi5)
CPU: Intel Core i5-1135G7 (4 cores, 8 threads)
iGPU: Intel Iris Xe Graphics (for hardware transcoding)
RAM: 16GB DDR4-3200
Storage: 
  - 512GB NVMe SSD (system + configs)
  - 4TB 2.5" HDD (media library)
Network: Gigabit Ethernet
Power: 65W adapter

Total cost: $650 (NUC + RAM + drives)
Power usage: 25W average, 45W under load
Monthly electricity: ~$6
```

## Services Running

```
Core Services:
1. Traefik - Reverse proxy with SSL
2. Authelia - 2FA protection
3. Pi-hole - DNS & ad blocking
4. Vaultwarden - Password manager
5. Portainer - Docker GUI
6. Watchtower - Auto-updates

Media Stack:
7. Jellyfin - Media streaming (4K capable)
8. Sonarr - TV show management
9. Radarr - Movie management
10. Prowlarr - Indexer manager
11. qBittorrent - Download client
12. Overseerr - Request management

Extras:
13. Uptime Kuma - Monitoring
14. Nextcloud - File sync
15. Homepage - Dashboard

Total RAM usage: 11GB / 16GB
CPU load: 
  - Idle: 5-10%
  - Streaming (1 4K): 35-50%
  - Streaming (2 1080p): 25-40%
Storage used: 
  - System: 180GB / 512GB
  - Media: 2.8TB / 4TB
```

## Network Diagram

```
Internet
   │
Router (192.168.1.1)
   │
   ├─> Port Forward 80,443 -> NUC
   │
NUC (192.168.1.50)
   │
   ├─> Pi-hole :53 (local DNS)
   │   └─> Returns 192.168.1.50 for *.home.local
   │
   ├─> Traefik :80,:443
   │   ├─> Authelia (protects everything)
   │   ├─> jellyfin.home.local -> Jellyfin
   │   ├─> sonarr.home.local -> Sonarr
   │   ├─> radarr.home.local -> Radarr
   │   ├─> cloud.home.local -> Nextcloud
   │   └─> dash.home.local -> Homepage
   │
   └─> Downloads stored on 4TB HDD
```

## Deployment Process

```bash
# 1. Install Ubuntu Server 22.04 on NUC
# 2. Configure static IP
sudo nano /etc/netplan/00-installer-config.yaml
# Set IP: 192.168.1.50

# 3. Mount 4TB drive
sudo mkdir /mnt/media
sudo mount /dev/sdb1 /mnt/media
# Add to /etc/fstab for auto-mount

# 4. Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# 5. Create media directories
sudo mkdir -p /mnt/media/{movies,tv,downloads}
sudo chown -R $USER:$USER /mnt/media

# 6. Deploy services
cd ~/homelab
./scripts/deploy-core.sh
./scripts/deploy-media.sh

# 7. Configure Jellyfin hardware transcoding
# In Jellyfin dashboard:
# Settings -> Playback -> Hardware acceleration -> Intel QuickSync

# Total time: 1 hour
```

## Monthly Usage Stats

```
Media Library:
- Movies: 287 (1.9TB)
- TV Shows: 52 series (900GB)
- Total: 2.8TB

Streaming Stats (per month):
- Total streams: 450
- Unique users: 5 (family)
- Peak concurrent: 3
- 4K streams: 15%
- 1080p streams: 85%
- Average duration: 1.5 hours

Bandwidth:
- Upstream (remote): 120GB/month
- Local network: 800GB/month

Transcoding:
- Hardware transcoding: 95%
- CPU usage during transcode: 30-40%
- Power during transcode: 35-45W
```

## Cost Comparison

**Before Homelab (Monthly):**
```
Netflix (4K):        $20
Disney+:            $14
Hulu:               $18
HBO Max:            $16
Apple TV+:          $10
Amazon Prime Video: $9
Spotify Family:     $17
Total:              $104/month = $1,248/year
```

**After Homelab:**
```
Electricity: $6/month = $72/year
Internet (same): $0 extra
Usenet (optional): $5/month = $60/year
Domain: $15/year
Total: $147/year

Savings: $1,101/year
ROI: 7 months (hardware paid off)
```

## Performance Benchmarks

```
Jellyfin Transcoding Tests:

4K HEVC -> 1080p H264:
- Hardware: 0.8x realtime (35% CPU)
- Software: Would max out CPU

1080p H264 -> 720p:
- Hardware: Instant (15% CPU)
- Can handle 4+ streams

Multiple Streams:
- 1x 4K + 2x 1080p: 60% CPU, smooth
- 3x 1080p: 45% CPU, smooth
- 4x 1080p: 70% CPU, occasional buffer
```

## Why This Setup Works

**Pros:**
- Intel QuickSync handles 4K transcoding
- Enough RAM for all services
- Low power for 24/7 operation
- Quiet (can be in living room)
- Powerful enough for 3-4 streams
- Room for more services

**Cons:**
- Limited to 4TB (can add USB drives)
- Single point of failure
- No redundancy
- Limited to ~4 concurrent streams

## Family Feedback

**Wife:** "It's like Netflix but with all our stuff. Love it!"  
**Kids:** "Why can't I find [removed show]?" - Teaching moment  
**Remote family:** "Works great over VPN"  
**Me:** Best project ever  

## Lessons Learned

1. **Hardware transcoding is essential** - Tried without first, CPU couldn't handle it
2. **Storage fills up fast** - Started with 2TB, needed 4TB within 3 months
3. **Automated management saves time** - Sonarr/Radarr auto-grab new episodes
4. **2FA is annoying but worth it** - Authelia keeps it secure
5. **Local network is fast** - Gigabit makes 4K streaming instant
6. **Backup strategy crucial** - Learned this the hard way

## Common Questions I Get

**Q: Is it legal?**  
A: Yes, streaming your own media is legal. How you obtain it matters.

**Q: Can others use it remotely?**  
A: Yes, via VPN or exposing Jellyfin (with Authelia 2FA)

**Q: Does it work on phones/tablets?**  
A: Yes, Jellyfin has apps for iOS, Android, Roku, Fire TV

**Q: What if hardware fails?**  
A: I backup configs weekly, media is replaceable

**Q: How long does content take to appear?**  
A: TV shows: Usually within hours of airing  
    Movies: When I add them  
    Automated with Sonarr/Radarr

## Future Upgrades

**Short term (next 6 months):**
- Add 8TB drive for more storage
- Deploy Tautulli for better stats
- Add Bazarr for subtitles

**Long term (1-2 years):**
- Build second server for high availability
- Move to Proxmox for VMs
- Add proper backup solution (TrueNAS)
- Upgrade to 10Gb networking

## Would I Recommend This?

**Absolutely yes if:**
- You watch a lot of media
- You have 3+ streaming subscriptions
- You want to learn Docker
- You have basic Linux skills
- You have $600-800 budget

**Maybe not if:**
- You only watch one service occasionally
- You don't want to manage anything
- You can't be bothered with troubleshooting
- Budget is very tight

## Stats After 1 Year

```
Uptime: 99.7% (only maintenance reboots)
Services added since start: 8 (started with 7)
Hardware failures: 0
Family satisfaction: 10/10
Subscriptions cancelled: 6 ($104/month saved)
Total saved: $1,100
Hardware cost: $650
Net savings: $450 in year 1

Year 2 projections: $1,248 saved (pure profit)
```

**Best $650 I ever spent.**

## Screenshots

(Would include actual screenshots here):
- Jellyfin library view
- Sonarr calendar
- Traefik dashboard
- Homepage dashboard
- Uptime Kuma monitoring

## Tips for Others

1. **Start small** - Don't deploy everything at once
2. **Hardware transcoding** - Essential for media servers
3. **Organize media properly** - Follow naming conventions
4. **Monitor everything** - Uptime Kuma is your friend
5. **Backup configs** - Docker volumes can be recreated, configs can't
6. **Ask family first** - Make sure they're okay with self-hosting
7. **Plan for growth** - Storage fills up faster than you think

## Contact

Happy to answer questions! Find me on r/homelab or r/jellyfin
