# Nextcloud - Self-Hosted Cloud Storage


## What is Nextcloud?

Nextcloud is a self-hosted productivity platform that provides file storage, collaboration tools, calendar, contacts, and much more - all under your control.

Basically:
- Your own Google Drive + Google Calendar + Google Contacts
- Dropbox replacement you own
- Microsoft 365 without Microsoft

What it does:
- Unlimited storage (limited only by your hardware)
- Sync across all devices
- Share files with anyone
- Calendar & contacts sync
- Collaborative document editing
- 100% privacy - your data, your server
- Free and open-source

## Why You Need This

**Cloud storage services:**
```
Google Drive: $10/month (200GB) = $120/year
Dropbox: $12/month (2TB) = $144/year
Microsoft 365: $7/month = $84/year
Total: $348/year for limited storage
```

**Nextcloud:**
```
Cost: $0 (use your own storage)
Storage: Unlimited (add more drives)
Privacy: Complete
Features: Everything included
```

## Prerequisites

### Required
- [ ] Docker & Docker Compose installed
- [ ] Traefik deployed (for HTTPS)
- [ ] Domain name or subdomain
- [ ] Database (MariaDB/PostgreSQL - included in compose)
- [ ] Storage space for files

### Recommended
- [ ] 2GB+ RAM for smooth operation
- [ ] SSD for database performance
- [ ] Regular backup strategy

## Quick Start

### 1. Deploy Nextcloud

```bash
# Navigate to directory
cd Nextcloud

# Start Nextcloud + Database
docker compose up -d

# Check logs
docker compose logs -f nextcloud

# Wait for "ready to handle connections"
```

### 2. Initial Setup

1. Open browser
2. Go to: `https://cloud.yourdomain.com`
3. Create admin account:
 - Username: admin (or your choice)
 - Password: Use strong password from Vaultwarden!
4. Configure database:
 - Database: PostgreSQL
 - User: nextcloud
 - Password: (from docker-compose.yml)
 - Database: nextcloud
 - Host: db:5432
5. Click "Finish setup"
6. Wait 2-3 minutes for initialization

### 3. Install Desktop Client

**Windows/Mac/Linux:**
1. Download from: https://nextcloud.com/install/#install-clients
2. Install application
3. Open Nextcloud client
4. Add account: `https://cloud.yourdomain.com`
5. Login with admin credentials
6. Choose sync folder
7. Files sync automatically!

### 4. Install Mobile App

**iOS/Android:**
1. Download "Nextcloud" from App Store/Play Store
2. Enter server: `https://cloud.yourdomain.com`
3. Login
4. Enable auto-upload for photos (optional)

Done. You now have your own cloud storage!

## File Structure

```
Nextcloud/
 docker-compose.yaml # Configuration
 nextcloud/ # Nextcloud data (auto-created)
 config/ # Nextcloud config
 data/ # User files stored here
 apps/ # Installed apps
 db/ # Database data
 README.md # This file
```

## Configuration

### docker-compose.yml Explained

```yaml
version: '3'

services:
 # Database
 db:
 image: postgres:15-alpine
 container_name: nextcloud-db
 restart: unless-stopped
 volumes:
 - ./db:/var/lib/postgresql/data
 environment:
 POSTGRES_DB: nextcloud
 POSTGRES_USER: nextcloud
 POSTGRES_PASSWORD: change-this-password # Change this!
 networks:
 - nextcloud-net

 # Nextcloud
 nextcloud:
 image: nextcloud:latest
 container_name: nextcloud
 restart: unless-stopped
 depends_on:
 - db
 volumes:
 - ./nextcloud:/var/www/html
 environment:
 - POSTGRES_HOST=db
 - POSTGRES_DB=nextcloud
 - POSTGRES_USER=nextcloud
 - POSTGRES_PASSWORD=change-this-password # Match above!
 - NEXTCLOUD_ADMIN_USER=admin
 - NEXTCLOUD_ADMIN_PASSWORD=change-admin-password
 - NEXTCLOUD_TRUSTED_DOMAINS=cloud.yourdomain.com
 - OVERWRITEPROTOCOL=https
 labels:
 - "traefik.enable=true"
 - "traefik.http.routers.nextcloud.rule=Host(`cloud.${DOMAIN}`)"
 - "traefik.http.routers.nextcloud.entrypoints=websecure"
 - "traefik.http.services.nextcloud.loadbalancer.server.port=80"
 
 # WebDAV redirect middleware
 - "traefik.http.middlewares.nextcloud-redirectregex.redirectRegex.permanent=true"
 - "traefik.http.middlewares.nextcloud-redirectregex.redirectRegex.regex=https://(.*)/.well-known/(card|cal)dav"
 - "traefik.http.middlewares.nextcloud-redirectregex.redirectRegex.replacement=https://$$1/remote.php/dav/"
 - "traefik.http.routers.nextcloud.middlewares=nextcloud-redirectregex"
 networks:
 - traefik
 - nextcloud-net

networks:
 traefik:
 external: true
 nextcloud-net:
 internal: true
```

### Important Settings

**POSTGRES_PASSWORD:**
```bash
# Generate secure password
openssl rand -base64 32
```

**NEXTCLOUD_TRUSTED_DOMAINS:**
- Must include your domain
- Can add multiple: `cloud.domain1.com cloud.domain2.com`

**OVERWRITEPROTOCOL:**
- Set to `https` when using Traefik
- Tells Nextcloud it's behind reverse proxy

## Customization

### Enable Apps

Settings → Apps:

**Recommended:**
- **Contacts** - Sync contacts (like Google Contacts)
- **Calendar** - Sync calendars (like Google Calendar)
- **Tasks** - To-do lists
- **Deck** - Kanban board (like Trello)
- **Notes** - Note-taking
- **Memories** - Photo timeline (like Google Photos)
- **OnlyOffice** or **Collabora** - Office documents

**Productivity:**
- **Forms** - Create surveys
- **Mail** - Email client
- **Talk** - Video calls
- **Polls** - Create polls

**Organization:**
- **Group folders** - Shared team folders
- **External storage** - Mount SMB, S3, etc.

### Install OnlyOffice for Document Editing

Add to docker-compose.yml:

```yaml
services:
 onlyoffice:
 image: onlyoffice/documentserver:latest
 container_name: onlyoffice
 restart: unless-stopped
 environment:
 - JWT_SECRET=change-this-secret
 labels:
 - "traefik.enable=true"
 - "traefik.http.routers.onlyoffice.rule=Host(`office.${DOMAIN}`)"
 - "traefik.http.routers.onlyoffice.entrypoints=websecure"
 - "traefik.http.services.onlyoffice.loadbalancer.server.port=80"
 networks:
 - traefik
 - nextcloud-net
```

Then in Nextcloud:
1. Settings → Apps → Office & text → OnlyOffice
2. Settings → OnlyOffice → Server: `https://office.yourdomain.com`
3. JWT Secret: (from docker-compose.yml)

### Increase Upload Size

Edit `nextcloud/config/config.php`:

```php
'max_chunk_size' => 1073741824, // 1GB chunks
```

Or via command:
```bash
docker exec -u www-data nextcloud php occ config:system:set max_chunk_size --value=1073741824
```

### External Storage

Mount network drives:

1. Settings → Administration → External storage
2. Add storage:
 - Type: SMB/CIFS (network share)
 - Host: 192.168.1.100
 - Share: /media
 - Username/Password
3. Save

### Theming

Settings → Administration → Theming:
- Upload logo
- Change colors
- Set background image
- Custom name

## Security Best Practices

### 1. Strong Admin Password

Use Vaultwarden to generate secure password:
```bash
openssl rand -base64 32
```

### 2. Enable 2FA

Settings → Security → Two-Factor Authentication:
- Install "Two-Factor TOTP Provider" app
- Enable for admin account
- Scan QR with authenticator app
- Save recovery codes!

### 3. Protect with Authelia

Add to docker-compose.yml labels:
```yaml
- "traefik.http.routers.nextcloud.middlewares=authelia@docker"
```

### 4. Server-Side Encryption

Settings → Administration → Security:
- Enable server-side encryption
- Encrypt all files

**Note:** Backup encryption keys!

### 5. Brute Force Protection

Already enabled by default.

Check: Settings → Security → Brute-force settings

### 6. Regular Backups

```bash
# Backup script
#!/bin/bash
# Stop containers
docker compose down

# Backup files
tar -czf nextcloud-backup-$(date +%Y%m%d).tar.gz \
 nextcloud/ \
 db/

# Start containers
docker compose up -d

# Upload backup
rclone copy nextcloud-backup-*.tar.gz remote:backups/
```

### 7. Security Scan

Run security scan:
```bash
docker exec -u www-data nextcloud php occ security:check
```

### 8. HTTPS Only

Force HTTPS (handled by Traefik + OVERWRITEPROTOCOL).

## Sync Everything

### Files

Desktop client syncs folders automatically.

Mobile app:
- Auto-upload photos/videos
- Offline files
- Share from other apps

### Calendar

**Desktop:**
- Thunderbird: Lightning add-on
- Apple Calendar: Add CalDAV account
- Outlook: Use CalDAV Synchronizer

**Mobile:**
- iOS: Settings → Calendar → Add Account → Other → CalDAV
- Android: DAVx5 app from Play Store

URL: `https://cloud.yourdomain.com/remote.php/dav`

### Contacts

**Desktop:**
- Thunderbird: CardBook add-on
- Apple Contacts: Add CardDAV account
- Windows: Various CardDAV apps

**Mobile:**
- iOS: Settings → Contacts → Add Account → Other → CardDAV
- Android: DAVx5 app

URL: `https://cloud.yourdomain.com/remote.php/dav`

### Tasks

Use Tasks app + CalDAV sync (same as calendar).

## Troubleshooting

### Issue: "Trusted Domain" Error

**Error:** "Access through untrusted domain"

**Fix:**
```bash
# Add your domain to trusted domains
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 1 --value=cloud.yourdomain.com

# Or edit config.php manually
nano nextcloud/config/config.php

# Add to trusted_domains array:
'trusted_domains' =>
 array (
 0 => 'localhost',
 1 => 'cloud.yourdomain.com',
 ),
```

### Issue: Database Connection Failed

**Check:**
1. Database container running?
 ```bash
 docker ps | grep nextcloud-db
 ```

2. Passwords match in docker-compose.yml?

3. Database accessible?
 ```bash
 docker exec -it nextcloud-db psql -U nextcloud -d nextcloud
 ```

### Issue: Can't Upload Large Files

**Fix:**
1. Check client upload limit
2. Increase chunk size (see Customization)
3. Check reverse proxy timeout:
 
 In Traefik config:
 ```yaml
 - "traefik.http.services.nextcloud.loadbalancer.server.timeout=300s"
 ```

### Issue: WebDAV/CalDAV Not Working

**Fix redirect middleware** (should be in docker-compose.yml):
```yaml
- "traefik.http.middlewares.nextcloud-redirectregex.redirectRegex.regex=https://(.*)/.well-known/(card|cal)dav"
- "traefik.http.middlewares.nextcloud-redirectregex.redirectRegex.replacement=https://$$1/remote.php/dav/"
```

### Issue: Slow Performance

**Optimize:**
1. **Use Redis for caching:**
 
 Add to docker-compose.yml:
 ```yaml
 redis:
 image: redis:alpine
 container_name: nextcloud-redis
 restart: unless-stopped
 networks:
 - nextcloud-net
 ```
 
 Configure Nextcloud:
 ```bash
 docker exec -u www-data nextcloud php occ config:system:set redis host --value=redis
 docker exec -u www-data nextcloud php occ config:system:set redis port --value=6379
 docker exec -u www-data nextcloud php occ config:system:set memcache.locking --value='\OC\Memcache\Redis'
 ```

2. **Database maintenance:**
 ```bash
 docker exec -u www-data nextcloud php occ db:add-missing-indices
 docker exec -u www-data nextcloud php occ db:convert-filecache-bigint
 ```

3. **Use SSD** for database and Nextcloud data

### Issue: Background Jobs Not Running

**Fix:**
```bash
# Set cron for background jobs
docker exec -u www-data nextcloud php occ background:cron
```

Add to crontab on host:
```bash
*/5 * * * * docker exec -u www-data nextcloud php occ background:cron
```

## Updating

```bash
# Backup first!
tar -czf nextcloud-backup-$(date +%Y%m%d).tar.gz nextcloud/ db/

# Update
docker compose pull
docker compose up -d

# Run upgrade (if needed)
docker exec -u www-data nextcloud php occ upgrade

# Check status
docker compose logs -f nextcloud
```

**After update:**
- Test login
- Test file upload/download
- Test sync clients
- Check installed apps

## Tips & Tricks

### 1. Shared Links

Share files with anyone:
- Right-click file/folder → Share
- Create public link
- Optional: Set password, expiration date
- Share link with anyone!

### 2. Collaborative Editing

With OnlyOffice/Collabora:
- Multiple users edit same document
- Real-time changes
- Like Google Docs!

### 3. Photo Auto-Upload

Mobile app:
- Settings → Auto upload
- Choose folders to auto-backup
- Like Google Photos backup!

### 4. Desktop Sync Selective

Don't want to sync everything?
- Right-click Nextcloud tray icon
- Settings → Choose what to sync
- Select specific folders

### 5. File Versioning

Nextcloud keeps file versions:
- Right-click file → Versions
- Restore previous version
- Like "undo" for files!

### 6. Activity Stream

See all changes:
- Click Activity icon
- See who accessed what
- Filter by type

### 7. occ Command

Powerful command-line tool:
```bash
# List all commands
docker exec -u www-data nextcloud php occ list

# Add user
docker exec -u www-data nextcloud php occ user:add username

# Scan files
docker exec -u www-data nextcloud php occ files:scan --all
```

## Related Services

**Deploy these next:**
1. **OnlyOffice** - Document editing
2. **Collabora** - Alternative document editor
3. **Backup solution** - Automated backups

**Nextcloud works great with:**
- Authelia (2FA protection)
- Traefik (remote access)
- External storage (SMB shares, S3)

## Additional Resources

- [Official Nextcloud Docs](https://docs.nextcloud.com/)
- [Admin Manual](https://docs.nextcloud.com/server/latest/admin_manual/)
- [Desktop Client Manual](https://docs.nextcloud.com/desktop/latest/)
- [r/NextCloud](https://reddit.com/r/NextCloud)

## Getting Help

**Before asking for help:**
1. Check logs: `docker compose logs nextcloud`
2. Check database logs: `docker compose logs db`
3. Run security check: `docker exec -u www-data nextcloud php occ security:check`
4. Note Nextcloud version: Settings → Administration → Overview

**Common issues:**
- Trusted domains not configured
- Database connection errors
- Reverse proxy misconfiguration
- Permission issues

**Ask in:**
- r/NextCloud
- Nextcloud Forums
- r/selfhosted

## Success Checklist

- [ ] Nextcloud accessible via browser
- [ ] Admin account created
- [ ] Desktop client installed and syncing
- [ ] Mobile app installed
- [ ] Calendar/Contacts syncing (optional)
- [ ] 2FA enabled on admin account
- [ ] Recommended apps installed
- [ ] Backup strategy in place
- [ ] Trusted domains configured
- [ ] Performance optimization done (Redis, etc.)

---

**Next Steps:**
1. Install OnlyOffice for document editing
2. Set up calendar and contacts sync
3. Enable 2FA for all users
4. Configure automated backups
5. Explore apps (Deck, Notes, Talk)

**Congratulations! You've ditched Google/Microsoft clouds! **
