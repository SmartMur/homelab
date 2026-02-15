# 🛡️ Pi-hole - Network-Wide Ad Blocking

> **Difficulty:** 🟢 Beginner  
> **RAM Required:** 512MB  
> **Deployment Time:** 10-15 minutes

## 📖 What is Pi-hole?

Pi-hole is a network-level advertisement and internet tracker blocking application that acts as a DNS sinkhole.

**Think of it as:**
- A security guard at your network's front door
- An ad blocker for EVERY device (even apps!)
- A DNS server that blocks malicious domains

**Benefits:**
- 🚫 Block ads network-wide (phones, tablets, smart TVs, IoT devices)
- 🔒 Block tracking and telemetry
- ⚡ Faster browsing (ads never load)
- 📊 See what devices are requesting
- 💰 Save bandwidth

## ✅ Why You Need This

**Without Pi-hole:**
```
Your Device → ISP DNS → Ad Server → Ad Loads
```

**With Pi-hole:**
```
Your Device → Pi-hole → (blocked!) → Ad Never Loads
```

**Results:**
- ✅ Ads blocked on ALL devices automatically
- ✅ Works in apps where browser extensions can't
- ✅ Protects guest devices
- ✅ Blocks malware/phishing domains
- ✅ Privacy from tracking domains

## 📋 Prerequisites

### Required
- [ ] Docker & Docker Compose installed
- [ ] Static IP for your server (or DHCP reservation)
- [ ] Port 53 available (DNS)
- [ ] Port 80 available (Web UI) - or use different port

### Understanding
- [ ] Know your router's IP
- [ ] Know how to access router settings
- [ ] Understand what DNS is

## 🚀 Quick Start

### Step 1: Check Port 53

Port 53 is used by DNS. Some systems have a service using it:

```bash
# Check if port 53 is in use
sudo netstat -tulpn | grep :53

# If systemd-resolved is using it (Ubuntu):
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved

# Remove the symlink
sudo rm /etc/resolv.conf

# Create new resolv.conf
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
```

### Step 2: Deploy Pi-hole

```bash
# Navigate to Pi-hole directory
cd Pihole

# Deploy
docker compose up -d

# Check it's running
docker ps | grep pihole

# Get admin password
docker logs pihole | grep "random password"
```

### Step 3: Access Web Interface

1. Open browser
2. Go to: `http://YOUR-SERVER-IP/admin`
3. Login with password from logs

### Step 4: Configure Devices to Use Pi-hole

**Option A: Router-Level (Recommended - Affects All Devices)**
1. Access your router settings (usually http://192.168.1.1)
2. Find DHCP settings
3. Change primary DNS to Pi-hole IP (e.g., 192.168.1.100)
4. Save and reboot router
5. Devices will automatically use Pi-hole

**Option B: Per-Device**
1. Go to device network settings
2. Change DNS to Pi-hole IP
3. Repeat for each device

### Step 5: Verify It's Working

1. Visit: http://pi.hole/admin (magic domain!)
2. Go to Dashboard
3. Browse websites on your devices
4. Watch the query log fill up
5. See ads get blocked! 🎉

## 📁 File Structure

```
Pihole/
├── docker-compose.yml        # Main configuration
├── pihole/                   # Pi-hole data (auto-created)
│   ├── pihole-FTL.db        # Query database
│   └── custom.list          # Custom DNS records
├── dnsmasq.d/               # DNS configuration
└── README.md                # This file
```

## 🔧 Configuration

### docker-compose.yml Explained

```yaml
services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"      # DNS TCP
      - "53:53/udp"      # DNS UDP
      - "80:80/tcp"      # Web interface (change if needed)
    environment:
      TZ: 'America/New_York'              # Your timezone
      WEBPASSWORD: 'changeme'             # Admin password
      SERVERIP: '192.168.1.100'           # Your server IP
      DNS1: '1.1.1.1'                     # Upstream DNS 1
      DNS2: '1.0.0.1'                     # Upstream DNS 2
    volumes:
      - './pihole:/etc/pihole'
      - './dnsmasq.d:/etc/dnsmasq.d'
    restart: unless-stopped
```

### Important Settings

**TZ** - Timezone for logs
```yaml
TZ: 'America/New_York'  # Find yours: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
```

**WEBPASSWORD** - Admin password
```yaml
WEBPASSWORD: 'your-secure-password-here'
```

**Upstream DNS** - Where Pi-hole forwards non-blocked queries
```yaml
DNS1: '1.1.1.1'    # Cloudflare
DNS2: '1.0.0.1'    # Cloudflare backup
# Or use:
# 8.8.8.8          # Google
# 9.9.9.9          # Quad9
```

## 🎨 Customization

### Change Web Interface Port

If port 80 is taken:

```yaml
ports:
  - "8080:80/tcp"  # Access on port 8080
```

Then access: `http://YOUR-IP:8080/admin`

### Add Custom Blocklists

1. Go to Pi-hole admin
2. Group Management → Adlists
3. Add URL
4. Tools → Update Gravity

**Popular blocklists:**
```
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://v.firebog.net/hosts/lists.php?type=tick
```

### Whitelist Domains

Some sites break with aggressive blocking:

1. Go to Whitelist
2. Add domain (e.g., `example.com`)
3. Save

**Common to whitelist:**
- `s.youtube.com` - YouTube history
- `api.ipify.org` - IP check services
- Your smart home devices

### Custom DNS Records

Create local DNS entries:

```bash
# Edit custom.list
nano pihole/custom.list

# Add entries (IP  domain)
192.168.1.50  nas.local
192.168.1.100 homelab.local
192.168.1.101 jellyfin.local
```

Restart Pi-hole:
```bash
docker restart pihole
```

## 🔒 Security Best Practices

### 1. Strong Admin Password

```bash
# Generate secure password
openssl rand -base64 32

# Update in docker-compose.yml
WEBPASSWORD: 'generated-password-here'

# Recreate container
docker compose up -d
```

### 2. Don't Expose to Internet

**Never** make Pi-hole accessible from the internet!
- Only use on local network
- If remote access needed, use VPN (WireGuard)

### 3. Use DNSSEC

Enable in Pi-hole settings:
1. Settings → DNS
2. Check "Use DNSSEC"
3. Save

### 4. Regular Updates

```bash
# Update Pi-hole
docker compose pull
docker compose up -d
```

### 5. Backup Configuration

```bash
# Backup entire Pi-hole directory
tar -czf pihole-backup-$(date +%Y%m%d).tar.gz pihole/

# Restore
tar -xzf pihole-backup-YYYYMMDD.tar.gz
```

## 📊 Monitoring & Statistics

### Dashboard Overview

Access: `http://pi.hole/admin`

**You can see:**
- Total queries today
- Queries blocked
- Percentage blocked
- Top blocked domains
- Top clients (devices)
- Query types (A, AAAA, etc.)

### Query Log

View real-time DNS queries:
1. Go to Query Log
2. See every DNS request
3. Allow/Block individual domains
4. See which device made request

### Long-term Statistics

Pi-hole keeps historical data:
- Daily graphs (30 days)
- Top domains over time
- Client activity patterns

## 🐛 Troubleshooting

### Issue: Can't Access Web Interface

**Check:**
```bash
# Is Pi-hole running?
docker ps | grep pihole

# Check logs
docker logs pihole

# Try accessing via IP
http://192.168.1.100/admin
```

**Common causes:**
- Wrong IP address
- Port 80 conflict
- Container not running

### Issue: Devices Not Using Pi-hole

**Verify DNS:**
```bash
# On device, check DNS server
# Windows:
ipconfig /all | findstr "DNS"

# Linux/Mac:
cat /etc/resolv.conf

# Should show Pi-hole IP
```

**Common causes:**
- Router DHCP not updated
- Device has static DNS set
- DNS cache (flush it!)

### Issue: Some Sites Not Loading

**Check:**
```bash
# View query log in Pi-hole
# Find blocked domain
# Whitelist if legitimate
```

**Common false positives:**
- Microsoft Office telemetry
- Apple iCloud services
- Smart TV functionality

**Solution:** Whitelist specific domains

### Issue: Ads Still Showing

**Reasons:**
1. **DNS cache** - Flush on device
   ```bash
   # Windows
   ipconfig /flushdns
   
   # Mac
   sudo dscacheutil -flushcache
   
   # Linux
   sudo systemd-resolve --flush-caches
   ```

2. **Hard-coded DNS** - Some apps bypass Pi-hole
   - Use firewall to force all DNS through Pi-hole

3. **Not using Pi-hole DNS** - Verify with `nslookup`

4. **Ads served from same domain** - Pi-hole can't block these (e.g., YouTube)

### Issue: Slow DNS Responses

**Check:**
```bash
# Test query speed
nslookup google.com

# Should be < 100ms
```

**Solutions:**
- Change upstream DNS (try different servers)
- Reduce blocklist size
- Increase Pi-hole resources (RAM)

### Issue: Container Won't Start - Port 53 in Use

**Find what's using port 53:**
```bash
sudo netstat -tulpn | grep :53
```

**If systemd-resolved:**
```bash
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
```

See "Ubuntu port 53 fix" file in this directory for detailed steps.

## 🔄 Updating

### Update Pi-hole Container

```bash
# Pull latest image
docker compose pull

# Recreate container (preserves data)
docker compose up -d

# Verify update
docker exec pihole pihole -v
```

### Update Blocklists

Automatic: Pi-hole updates weekly

Manual:
1. Tools → Update Gravity
2. Or: `docker exec pihole pihole -g`

## 🌐 Advanced Configuration

### Use Pi-hole with Traefik

Access Pi-hole via nice URL:

```yaml
# In Pi-hole docker-compose.yml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.pihole.rule=Host(`pihole.${DOMAIN}`)"
  - "traefik.http.routers.pihole.entrypoints=websecure"
  - "traefik.http.services.pihole.loadbalancer.server.port=80"

networks:
  - traefik

networks:
  traefik:
    external: true
```

### Conditional Forwarding

Forward local domain queries to router:

1. Settings → DNS
2. Advanced DNS Settings
3. Conditional Forwarding → Enable
4. Local network in CIDR: `192.168.1.0/24`
5. IP of DHCP server: `192.168.1.1` (router)
6. Local domain: `home` or `lan`

### Redundant Pi-hole

Run two Pi-holes for reliability:

1. Deploy second Pi-hole on different machine
2. Set router DNS:
   - Primary: First Pi-hole IP
   - Secondary: Second Pi-hole IP

### Block Everything by Default (Whitelist Mode)

Extreme privacy mode:

1. Settings → API → Privacy Mode → Anonymous
2. Group Management → Domains
3. Add only allowed domains to whitelist
4. Set default blocking in Settings

**Warning:** Very restrictive! Most sites will break.

## 📊 Statistics & Insights

### Top Blocked Domains

Usually see:
- `doubleclick.net` - Google ads
- `google-analytics.com` - Tracking
- `facebook.com` - Social widgets
- `amazon-adsystem.com` - Amazon ads

### Query Types

- **A** - IPv4 address lookup
- **AAAA** - IPv6 address lookup  
- **PTR** - Reverse DNS lookup

### Client Identification

Pi-hole shows client names if:
- Router provides hostname
- Or add custom names in Settings → DHCP

## 💡 Tips & Tricks

### 1. Test Blocking

Visit: http://pi.hole/admin/blockingtest
- Tests if Pi-hole is working

### 2. Temporary Disable

Click "Disable" in dashboard
- Disable for 30 seconds, 5 minutes, or custom
- Useful for troubleshooting

### 3. Regex Blocking

Block patterns:
```
# Block all subdomains
(\.|^)ads\..*$

# Block tracking parameters
.*\?utm_.*
```

### 4. Group Management

Organize:
- Create groups (Family, Kids, IoT)
- Apply different blocklists per group
- Assign devices to groups

### 5. API Access

Query Pi-hole programmatically:
```bash
# Get stats
curl http://pi.hole/admin/api.php

# Get top items
curl http://pi.hole/admin/api.php?topItems=10
```

## 📚 Related Services

**Deploy these next:**
1. **Unbound** - Recursive DNS (more privacy)
2. **Traefik** - Access Pi-hole via nice URL
3. **WireGuard** - Use Pi-hole when away from home

**Pi-hole works great with:**
- Unbound (recursive DNS)
- Cloudflare Tunnel (secure access)
- Home Assistant (block smart device telemetry)

## 📖 Additional Resources

- [Official Pi-hole Docs](https://docs.pi-hole.net/)
- [Pi-hole Discourse](https://discourse.pi-hole.net/)
- [Firebog Blocklists](https://firebog.net/)
- [r/pihole](https://reddit.com/r/pihole)

## 🆘 Getting Help

**Before asking for help:**
1. Check Pi-hole logs: `docker logs pihole`
2. Run diagnostics: Settings → Teleporter → Generate debug log
3. Note your Pi-hole version
4. Test with `nslookup`:
   ```bash
   nslookup google.com YOUR-PIHOLE-IP
   ```

**Ask in:**
- r/pihole
- Pi-hole Discourse
- r/selfhosted

## ✅ Success Checklist

- [ ] Pi-hole accessible at http://pi.hole/admin
- [ ] Dashboard shows queries being made
- [ ] Devices using Pi-hole as DNS
- [ ] Ads blocked (check dashboard percentage)
- [ ] Websites still load correctly
- [ ] Admin password changed from default
- [ ] Blocklists updated
- [ ] Backup created

---

**Next Steps:**
1. Add custom blocklists
2. Configure Conditional Forwarding
3. Set up Unbound for recursive DNS
4. Deploy WireGuard to use Pi-hole remotely

**Congratulations! You now have network-wide ad blocking! 🎉**
