# 🎬 Jellyfin - Free Media Server

> **Difficulty:** 🟡 Intermediate  
> **RAM Required:** 2GB (4GB+ for transcoding)  
> **Deployment Time:** 20-30 minutes

## 📖 What is Jellyfin?

Jellyfin is a free and open-source media server that lets you stream your movies, TV shows, music, and photos to any device.

**Think of it as:**
- Your personal Netflix
- Plex without the subscription fees
- Complete control over your media library

**Benefits:**
- 🎥 Stream movies/TV shows anywhere
- 📱 Apps for every device (iOS, Android, Roku, etc.)
- 🆓 100% free, no premium features locked
- 🔒 Your data stays on your server
- 🎨 Beautiful interface
- 👥 Multiple user profiles

## ✅ Why You Need This

**Cloud streaming services:**
```
Netflix: $15/month = $180/year
Disney+: $8/month = $96/year
Hulu: $8/month = $96/year
Total: $372/year + content disappears!
```

**Jellyfin:**
```
Cost: $0 (one-time hardware)
Content: Yours forever
Privacy: Complete
Offline: Works without internet
```

## 📋 Prerequisites

### Required
- [ ] Docker & Docker Compose installed
- [ ] Media files (movies, TV shows, music)
- [ ] Storage space (varies by library size)
- [ ] Traefik deployed (for remote access)

### Hardware Recommendations

**Minimum (720p streaming):**
- 2 cores CPU
- 2GB RAM
- No GPU needed

**Recommended (1080p, light transcoding):**
- 4 cores CPU
- 4GB RAM
- Intel QuickSync or GPU (optional)

**Optimal (4K, multiple streams):**
- 6+ cores CPU
- 8GB+ RAM
- Dedicated GPU (NVIDIA/Intel)

### Understanding
- [ ] What transcoding is
- [ ] Your media file formats
- [ ] Basic file organization

## 🚀 Quick Start

### Step 1: Organize Your Media

Create this folder structure:

```
/media/
├── movies/
│   ├── Avatar (2009)/
│   │   └── Avatar (2009).mkv
│   ├── Inception (2010)/
│   │   └── Inception (2010).mp4
│   └── ...
├── tv/
│   ├── Breaking Bad/
│   │   ├── Season 01/
│   │   │   ├── S01E01.mkv
│   │   │   ├── S01E02.mkv
│   │   │   └── ...
│   │   └── Season 02/
│   │       └── ...
│   └── ...
└── music/
    ├── Artist Name/
    │   ├── Album Name/
    │   │   ├── 01 - Song.mp3
    │   │   └── ...
    │   └── ...
    └── ...
```

**Naming conventions matter!**
- Movies: `Movie Name (Year)/Movie Name (Year).ext`
- TV: `Show Name/Season XX/SXXEXX.ext`

### Step 2: Configure docker-compose.yml

```bash
cd Jellyfin
nano docker-compose.yml
```

Update media paths to match yours:

```yaml
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    
    # IMPORTANT: Update these paths
    volumes:
      - ./config:/config
      - ./cache:/cache
      - /path/to/your/movies:/media/movies:ro  # READ ONLY
      - /path/to/your/tv:/media/tv:ro
      - /path/to/your/music:/media/music:ro
    
    environment:
      - TZ=America/New_York  # Your timezone
    
    ports:
      - "8096:8096"  # Web UI
    
    # Optional: GPU transcoding
    # devices:
    #   - /dev/dri:/dev/dri  # Intel QuickSync
    
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.jellyfin.rule=Host(`jellyfin.${DOMAIN}`)"
      - "traefik.http.routers.jellyfin.entrypoints=websecure"
      - "traefik.http.services.jellyfin.loadbalancer.server.port=8096"
    
    networks:
      - traefik

networks:
  traefik:
    external: true
```

### Step 3: Deploy Jellyfin

```bash
# Start Jellyfin
docker compose up -d

# Check logs
docker compose logs -f

# Verify running
docker ps | grep jellyfin
```

### Step 4: Initial Setup Wizard

1. Open browser
2. Go to: `http://YOUR-SERVER-IP:8096` or `https://jellyfin.yourdomain.com`
3. Select language
4. Create admin account
5. Set up media libraries:
   - Add Library → Movies → `/media/movies`
   - Add Library → TV Shows → `/media/tv`
   - Add Library → Music → `/media/music`
6. Configure remote access (if using Traefik)
7. Finish setup

### Step 5: Scan Library

1. Dashboard → Libraries
2. Click scan icon next to each library
3. Wait for scan to complete
4. Metadata and posters will download automatically

**🎉 Success!** Your personal streaming service is ready!

## 📁 File Structure

```
Jellyfin/
├── docker-compose.yaml     # Configuration
├── config/                 # Jellyfin config (auto-created)
│   ├── data/              # Database
│   ├── metadata/          # Posters, fanart
│   └── plugins/           # Installed plugins
├── cache/                 # Transcoding cache
└── README.md              # This file

/media/ (your media - separate location)
├── movies/
├── tv/
└── music/
```

## 🎨 Customization

### Enable Hardware Transcoding

**Intel QuickSync (Most Common):**

```yaml
services:
  jellyfin:
    devices:
      - /dev/dri:/dev/dri
    group_add:
      - "109"  # render group (check with: getent group render)
```

Then in Jellyfin:
1. Dashboard → Playback
2. Transcoding → Hardware acceleration: Intel QuickSync (QSV)
3. Enable hardware encoding
4. Save

**NVIDIA GPU:**

```yaml
services:
  jellyfin:
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
```

Requires: nvidia-docker runtime installed

**Test transcoding:**
Play video → Set quality to lower resolution → Check CPU usage

### Install Plugins

Dashboard → Plugins → Catalog:

**Recommended:**
- **TMDb** - Better metadata
- **Trakt** - Track watching progress
- **Fanart** - More artwork
- **Intro Skipper** - Skip TV show intros
- **Playback Reporting** - Watch statistics

### Custom Branding

Dashboard → General:
- Change server name
- Upload custom logo
- Set login message

### Libraries Organization

Create separate libraries for:
- Movies (4K) - 4K content separate
- Kids Movies - Family-friendly content
- Anime - Different metadata provider
- Concerts - Music videos

### User Management

Dashboard → Users:
- Create accounts for family
- Set parental controls
- Limit library access per user
- Set max streaming quality

**Example:**
- Kids: Only access "Kids Movies" library
- Guest: Limited to 720p streaming
- Admin: Full access

## 🔒 Security Best Practices

### 1. Protect with Authelia

```yaml
labels:
  - "traefik.http.routers.jellyfin.middlewares=authelia@docker"
```

Now requires 2FA before accessing Jellyfin.

### 2. Disable DLNA (If Not Needed)

Dashboard → Networking:
- Uncheck "Enable DLNA"
- Reduces attack surface

### 3. Use Strong Admin Password

Dashboard → Users → Admin → Edit:
- Change password
- Use Vaultwarden-generated password

### 4. Firewall Rules

Only allow necessary ports:
```bash
# If not using Traefik
sudo ufw allow 8096/tcp

# If using Traefik
# Port 8096 not exposed externally
```

### 5. Regular Updates

```bash
docker compose pull
docker compose up -d
```

### 6. Read-Only Media Mounts

In docker-compose.yml:
```yaml
volumes:
  - /media/movies:/media/movies:ro  # :ro = read-only
```

Jellyfin can't accidentally delete your media!

## 🎬 Client Apps

### Download Official Apps

**Mobile:**
- iOS: App Store → "Jellyfin"
- Android: Play Store → "Jellyfin"

**TV:**
- Roku: Search "Jellyfin"
- Fire TV: Amazon Appstore → "Jellyfin"
- Apple TV: App Store → "Jellyfin"
- Android TV: Play Store → "Jellyfin"

**Desktop:**
- Windows/Mac/Linux: https://jellyfin.org/downloads
- Or use web browser

**Setup:**
1. Open app
2. Add server: `https://jellyfin.yourdomain.com`
3. Login with credentials
4. Browse and stream!

### Browser Web App

Just visit: `https://jellyfin.yourdomain.com`

Works on any device with a browser!

## 📊 Understanding Transcoding

### What is Transcoding?

Converting media to format compatible with client device.

**Example:**
```
Original: 4K HEVC (too large for mobile)
↓ Transcoding
Output: 1080p H264 (mobile can play)
```

### When Does It Happen?

- Client doesn't support codec (e.g., HEVC on old device)
- Network too slow for original quality
- User selects lower quality
- Subtitles burned in

### Direct Play vs Transcode

**Direct Play (Best):**
- No conversion needed
- Low server CPU usage
- Best quality
- Instant playback

**Transcode (CPU Intensive):**
- Conversion required
- High server CPU/GPU usage
- Slight quality loss
- May buffer initially

**Goal:** Organize media for maximum Direct Play

### Optimal File Formats

**Video:**
- Codec: H264 or H265 (HEVC)
- Container: MP4 or MKV
- Resolution: 1080p (most compatible)

**Audio:**
- AAC stereo (most compatible)
- AC3 5.1 (if you have surround sound)

**Subtitles:**
- SRT (external file, best)
- ASS (for anime)

## 🐛 Troubleshooting

### Issue: Library Not Showing Media

**Check:**
1. File permissions:
   ```bash
   ls -la /media/movies
   # Should be readable by Jellyfin user
   ```

2. Folder structure correct?
   ```
   Movies/
     Avatar (2009)/
       Avatar (2009).mkv  ← Correct
   
   NOT:
   Movies/
     Avatar.mkv  ← Wrong (no subfolder)
   ```

3. Rescan library:
   Dashboard → Libraries → Scan

### Issue: Playback Stuttering/Buffering

**Causes:**
1. **Transcoding on weak CPU**
   - Enable hardware acceleration
   - Or: Re-encode media to H264

2. **Network too slow**
   - Lower quality in player
   - Use wired ethernet, not WiFi

3. **Disk too slow**
   - Use SSD for media
   - Or: Pre-convert media

**Check:**
Dashboard → Playback → Active Streams
- See if transcoding is happening
- Check reason for transcode

### Issue: Metadata/Posters Missing

**Solutions:**
1. Verify naming:
   - `Movie Name (Year)` format
   - `SXXEXX` for TV episodes

2. Identify library:
   Dashboard → Libraries → [Library] → Identify
   - Manually search and match

3. Refresh metadata:
   Right-click item → Refresh Metadata

4. Install TMDb plugin:
   Dashboard → Plugins → Catalog → TMDb

### Issue: Remote Access Not Working

**Check:**
1. Traefik labels correct?
2. DNS pointing to server?
3. Ports forwarded (if not using Traefik)?
4. HTTPS certificate valid?

**Test locally first:**
- Can you access via `http://LOCAL-IP:8096`?
- If yes → networking issue
- If no → Jellyfin issue

### Issue: Hardware Transcoding Not Working

**Intel QuickSync:**
```bash
# Check if /dev/dri exists
ls -la /dev/dri

# Check permissions
groups

# Should include 'render' or 'video'
```

**NVIDIA:**
```bash
# Check nvidia-smi works in container
docker exec jellyfin nvidia-smi
```

Enable in Dashboard → Playback → Hardware acceleration

## 🔄 Updating

```bash
# Backup config first
tar -czf jellyfin-backup-$(date +%Y%m%d).tar.gz config/

# Update
docker compose pull
docker compose up -d

# Check logs for errors
docker compose logs -f
```

**After update:**
- Check playback still works
- Verify hardware transcoding still enabled
- Test client apps

## 💡 Tips & Tricks

### 1. Collections

Group related movies:
- Marvel Cinematic Universe
- Lord of the Rings
- Studio Ghibli

Right-click movie → Add to Collection

### 2. Watch Together

Sync playback with friends:
- Right-click video → SyncPlay
- Share session with others
- Watch simultaneously!

### 3. Live TV & DVR

Add TV tuner:
1. Dashboard → Live TV
2. Add tuner device
3. Map channels
4. Schedule recordings

### 4. Intro Skipper Plugin

Auto-skip TV show intros:
1. Install "Intro Skipper" plugin
2. Let it analyze episodes
3. Skips intros automatically

### 5. Scheduled Tasks

Dashboard → Scheduled Tasks:
- Library scan at 3 AM daily
- Chapter image extraction
- Cleanup cache weekly

### 6. Mobile Downloads

In mobile app:
- Download videos for offline watching
- Perfect for travel

## 📚 Related Services

**Deploy these next:**
1. **Sonarr/Radarr** - Automated media management (not in repo)
2. **Overseerr** - Request system for users
3. **Tautulli** - Statistics and monitoring (Plex-focused but works)

**Jellyfin works great with:**
- Authelia (2FA protection)
- Traefik (remote access)
- Backup solution (for library metadata)

## 📖 Additional Resources

- [Official Jellyfin Docs](https://jellyfin.org/docs/)
- [Naming Guidelines](https://jellyfin.org/docs/general/server/media/movies.html)
- [Hardware Acceleration](https://jellyfin.org/docs/general/administration/hardware-acceleration.html)
- [r/jellyfin](https://reddit.com/r/jellyfin)

## 🆘 Getting Help

**Before asking for help:**
1. Check logs: `docker compose logs jellyfin`
2. Check file permissions: `ls -la /media`
3. Verify naming conventions
4. Test with one movie/episode first
5. Note Jellyfin version: Dashboard → About

**Common mistakes:**
- Wrong folder structure
- File permissions issues
- Network/firewall blocking
- Incorrect file naming

**Ask in:**
- r/jellyfin
- Jellyfin Forums
- r/selfhosted

## ✅ Success Checklist

- [ ] Jellyfin accessible via browser
- [ ] Media library scanned successfully
- [ ] Posters/metadata downloaded
- [ ] Can play videos (test Direct Play)
- [ ] Hardware transcoding enabled (if applicable)
- [ ] Remote access working (via Traefik)
- [ ] Mobile app installed and working
- [ ] User accounts created for family
- [ ] Backed up config directory
- [ ] Protected with Authelia (optional)

---

**Next Steps:**
1. Add more media to libraries
2. Install recommended plugins
3. Set up user accounts
4. Configure hardware transcoding
5. Enjoy your content!

**Congratulations! You've cut the cord and own your streaming! 🎬**
