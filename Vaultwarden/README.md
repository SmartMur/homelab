# Vaultwarden - Self-Hosted Password Manager


## What is Vaultwarden?

Vaultwarden is an unofficial Bitwarden server implementation written in Rust. It's compatible with Bitwarden's official clients and provides password management for free.

Basically:
- Your own personal 1Password/LastPass
- A secure vault for all passwords
- Bitwarden Premium features for free

What it does:
- All passwords in one encrypted vault
- Access from phone, laptop, browser
- Auto-sync across devices
- Self-hosted = you control the data
- Free (no subscription needed)
- Strong encryption (AES-256)

## Why You Need This

**Without a password manager:**
```
Gmail: MyPassword123
Facebook: MyPassword123 ← Same password = DANGEROUS!
Bank: Password456 ← Weak password = VULNERABLE!
Netflix: Forgot password... again
```

**With Vaultwarden:**
```
Gmail: k9$mP#xL2@qR8nW ← Unique, strong
Facebook: Q7!vN@4tY$pL1 ← Different per site
Bank: X3%jK&9rM#2dS8 ← Maximum security
Netflix: Auto-filled from vault
```

**Security benefits:**
- Never reuse passwords
- Generate strong, random passwords
- Auto-fill (no typing = no keyloggers)
- Know if passwords leaked in breaches
- Share passwords securely (family/team)

## Prerequisites

### Required
- [ ] Docker & Docker Compose installed
- [ ] Traefik deployed (for HTTPS)
- [ ] Domain name (or subdomain)

### Recommended
- [ ] Authelia deployed (add 2FA to vault access)
- [ ] Backup strategy planned

## Quick Start

### 1. Deploy Vaultwarden

```bash
# Navigate to directory
cd Vaultwarden

# Start Vaultwarden
docker compose up -d

# Check it's running
docker ps | grep vaultwarden

# Check logs
docker compose logs -f
```

### 2. Access Web Vault

1. Open browser
2. Go to: `https://vault.yourdomain.com` (or configured URL)
3. Click "Create Account"
4. Enter email and master password
5. Important: Master password is NOT recoverable! Write it down!

### 3. Install Browser Extension

**Chrome/Edge/Brave:**
1. Visit Chrome Web Store
2. Search "Bitwarden"
3. Install extension
4. Click extension icon
5. Settings → Set server URL: `https://vault.yourdomain.com`
6. Log in

**Firefox:**
1. Visit Firefox Add-ons
2. Search "Bitwarden"
3. Install
4. Configure same as above

### 4. Install Mobile App

**iOS/Android:**
1. Download "Bitwarden" from App Store/Play Store
2. Open app
3. Tap gear icon (Settings)
4. Server URL: `https://vault.yourdomain.com`
5. Log in

### 5. Add Your First Password

1. Click "+" in web vault or extension
2. Choose type: Login
3. Enter:
 - Name: Gmail
 - Username: your-email@gmail.com
 - Password: (or generate random)
 - URL: https://gmail.com
4. Save

Done. You now have a self-hosted password manager!

## File Structure

```
Vaultwarden/
 docker-compose.yaml # Main configuration
 data/ # Vault data (auto-created)
 db.sqlite3 # Database
 attachments/ # File attachments
 sends/ # Bitwarden Send files
 README.md # This file
```

## Configuration

### docker-compose.yml

```yaml
services:
 vaultwarden:
 image: vaultwarden/server:latest
 container_name: vaultwarden
 restart: unless-stopped
 
 environment:
 # Domain for emails and links
 DOMAIN: "https://vault.yourdomain.com"
 
 # Disable registration after creating account
 SIGNUPS_ALLOWED: "true" # Change to "false" after setup
 
 # Email configuration (optional but recommended)
 SMTP_HOST: smtp.gmail.com
 SMTP_FROM: your-email@gmail.com
 SMTP_PORT: 587
 SMTP_SECURITY: starttls
 SMTP_USERNAME: your-email@gmail.com
 SMTP_PASSWORD: your-app-password
 
 # Admin token (for admin panel)
 ADMIN_TOKEN: "generate-random-token"
 
 volumes:
 - ./data:/data
 
 labels:
 # Traefik labels
 - "traefik.enable=true"
 - "traefik.http.routers.vaultwarden.rule=Host(`vault.${DOMAIN}`)"
 - "traefik.http.routers.vaultwarden.entrypoints=websecure"
 - "traefik.http.services.vaultwarden.loadbalancer.server.port=80"
 
 networks:
 - traefik

networks:
 traefik:
 external: true
```

### Important Settings

**SIGNUPS_ALLOWED**
- `true` - Anyone can create account
- `false` - No new registrations (set after you create your account!)

**ADMIN_TOKEN**
Generate secure token:
```bash
openssl rand -base64 32
```

Access admin panel: `https://vault.yourdomain.com/admin`

**SMTP Configuration**
Enables password reset emails (highly recommended):
- Use Gmail App Password (not regular password)
- Or use any SMTP provider

## Security Best Practices

### 1. Strong Master Password

Your master password is EVERYTHING:
- **Length:** Minimum 16 characters
- **Complexity:** Mix of uppercase, lowercase, numbers, symbols
- **Unique:** Never used elsewhere
- **Memorable:** You can't reset it!

**Good master password examples:**
```
Correct-Horse-Battery-Staple-2024!
MyDog@ate3Homework#Papers
I<3Coffee&Code$Morning
```

**Terrible master passwords:**
```
password123
MyName2024
Summer2024
```

### 2. Disable Signups After Initial Setup

```yaml
environment:
 SIGNUPS_ALLOWED: "false" # No one else can register
```

Restart container:
```bash
docker compose up -d
```

### 3. Protect with Authelia

Add 2FA requirement in docker-compose.yml:

```yaml
labels:
 - "traefik.http.routers.vaultwarden.middlewares=authelia@docker"
```

Now Vaultwarden requires 2FA login!

### 4. Enable 2FA Within Vaultwarden

Even without Authelia, enable 2FA in Vaultwarden:

1. Web Vault → Settings
2. Two-step Login
3. Choose method:
 - Authenticator App (free)
 - Email (free)
 - YubiKey (if you have one)
4. Follow setup wizard
5. Save recovery codes!

### 5. Regular Backups

Vaultwarden data is CRITICAL:

```bash
# Backup script
#!/bin/bash
tar -czf vaultwarden-backup-$(date +%Y%m%d).tar.gz data/

# Upload to cloud
rclone copy vaultwarden-backup-*.tar.gz remote:backups/
```

Run weekly with cron:
```bash
0 2 * * 0 /path/to/backup-script.sh
```

### 6. Use Strong Admin Token

```bash
# Generate secure admin token
openssl rand -base64 48
```

Update docker-compose.yml and restart.

### 7. Monitor Failed Logins

Check logs regularly:
```bash
docker compose logs vaultwarden | grep -i "failed\|invalid"
```

## Hard Features

### Organizations (Password Sharing)

Share passwords with family/team:

1. Web Vault → New Organization
2. Name it (e.g., "Family")
3. Invite members via email
4. Share specific passwords with organization

**Use cases:**
- Family Netflix password
- Shared bank account
- Team API keys

### Bitwarden Send

Securely share sensitive data temporarily:

1. Web Vault → Send
2. Create new Send
3. Add text or file
4. Set expiration (1 hour, 1 day, 1 week)
5. Optional password protection
6. Share link

**Use cases:**
- Share WiFi password with guests
- Send API key to colleague
- Share document temporarily

### Collections

Organize passwords:

1. Create collection: "Work", "Personal", "Family"
2. Assign passwords to collections
3. Share collections with organization members

### Emergency Access

Grant access if something happens to you:

1. Settings → Emergency Access
2. Add trusted contact
3. Set wait time (e.g., 7 days)
4. Contact can request access
5. After wait time, they can see passwords

**Important for:**
- Spouse accessing accounts if you're unavailable
- Recovery of critical accounts

## Migration from Other Managers

### From LastPass

1. LastPass → More Options → Hard → Export
2. Save CSV file
3. Vaultwarden → Tools → Import Data
4. Select "LastPass (csv)"
5. Upload file
6. Verify import
7. Delete CSV file securely!

### From 1Password

1. 1Password → File → Export
2. Select "Comma Delimited Text (.csv)"
3. Vaultwarden → Import
4. Select "1Password (csv)"
5. Upload and verify

### From Chrome/Firefox

1. Browser → Settings → Passwords → Export
2. Save CSV
3. Vaultwarden → Import → Chrome/Firefox
4. Upload
5. Delete CSV securely

## Troubleshooting

### Issue: Can't Access Web Vault

**Check:**
```bash
# Is Vaultwarden running?
docker ps | grep vaultwarden

# Check logs
docker compose logs -f vaultwarden

# Test DNS
nslookup vault.yourdomain.com

# Test connectivity
curl https://vault.yourdomain.com
```

### Issue: Browser Extension Can't Connect

**Verify server URL:**
- Must include `https://`
- Must not end with `/`
- Example: `https://vault.yourdomain.com`

**Clear extension cache:**
1. Extension settings
2. Log out
3. Clear cache
4. Log back in

### Issue: Forgot Master Password

**Bad news:** Cannot be reset (by design).

**Options:**
1. If you have emergency access set up → use that
2. If you have a backup → restore it
3. Otherwise → create new account, start over

**Prevention:**
- Write down master password securely
- Store in physical safe
- Set up emergency access

### Issue: Mobile App Not Syncing

**Check:**
1. App settings → Server URL correct?
2. Logged in with correct account?
3. Network connectivity?
4. Try manual sync (pull down to refresh)

**Force sync:**
- Log out of app
- Log back in
- Pull to refresh

### Issue: "Invalid Master Password"

**Causes:**
1. Actually wrong password (caps lock?)
2. Copy/paste added extra space
3. Different account email

**Try:**
- Type password manually
- Check caps lock
- Verify email address
- Try on different device (verifies server issue)

## Monitoring & Maintenance

### Admin Panel

Access: `https://vault.yourdomain.com/admin`

**Features:**
- View registered users
- Delete users
- Disable 2FA for users (if locked out)
- View diagnostics
- Backup/restore

### Health Check

```bash
# Check container health
docker ps | grep vaultwarden

# Check disk usage
du -sh data/

# Check logs for errors
docker compose logs vaultwarden | grep -i error
```

### Database Maintenance

Vaultwarden uses SQLite by default:

```bash
# Check database size
ls -lh data/db.sqlite3

# Optimize database (compact)
sqlite3 data/db.sqlite3 "VACUUM;"
```

## Updating

```bash
# Pull latest image
docker compose pull

# Recreate container
docker compose up -d

# Verify update
docker logs vaultwarden | head
```

**Before updating:**
- Backup data directory
- Check release notes for breaking changes
- Test in development first (if critical)

## Tips & Tricks

### 1. Generate Strong Passwords

In web vault or extension:
1. Click "Generate Password"
2. Set length (16+ recommended)
3. Include symbols, numbers
4. Avoid ambiguous characters (if typing manually)

### 2. Password Health Report

Web Vault → Reports:
- **Exposed Passwords** - Found in data breaches
- **Reused Passwords** - Same password on multiple sites
- **Weak Passwords** - Too short or simple
- **Inactive 2FA** - Sites that support 2FA but you haven't enabled

Fix these to improve security!

### 3. Secure Notes

Store more than passwords:
- Software licenses
- WiFi passwords
- Recovery codes
- Passport numbers
- Credit card info

### 4. Auto-Fill Options

Configure extension behavior:
- Settings → Options
- Auto-fill on page load (convenient but less secure)
- Default URI match detection
- Clear clipboard after X seconds

### 5. Folder Organization

Create folders:
- Personal
- Work 
- Shared
- Old/Archived

Drag passwords into folders.

### 6. Browser Integration

Extension can:
- Auto-fill login forms
- Save new passwords automatically
- Generate passwords on signup forms
- Warn about reused passwords

## Related Services

**Deploy these next:**
1. **Authelia** - Add 2FA protection to Vaultwarden
2. **Backup solution** - Automated backups (restic/rClone)
3. **Monitoring** - Uptime Kuma to monitor availability

**Vaultwarden works great with:**
- Authelia (extra 2FA layer)
- Any service needing passwords
- Organization password sharing

## Additional Resources

- [Official Vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
- [Bitwarden Help Center](https://bitwarden.com/help/) (compatible)
- [r/Bitwarden](https://reddit.com/r/Bitwarden)
- [r/selfhosted](https://reddit.com/r/selfhosted)

## Getting Help

**Before asking for help:**
1. Check logs: `docker compose logs vaultwarden`
2. Verify configuration in docker-compose.yml
3. Test with curl: `curl -I https://vault.yourdomain.com`
4. Check Vaultwarden version: `docker logs vaultwarden | head`

**Common issues:**
- Server URL misconfigured in clients
- HTTPS required (not HTTP)
- Master password forgotten (unrecoverable)
- Backup data before troubleshooting!

**Ask in:**
- r/selfhosted
- Vaultwarden GitHub Discussions
- r/Bitwarden

## Success Checklist

- [ ] Vaultwarden accessible at https://vault.yourdomain.com
- [ ] Account created with strong master password
- [ ] Master password written down securely
- [ ] Browser extension installed and working
- [ ] Mobile app installed and syncing
- [ ] 2FA enabled (in Vaultwarden or via Authelia)
- [ ] SIGNUPS_ALLOWED set to false
- [ ] First backup completed
- [ ] Passwords imported from previous manager
- [ ] Emergency access configured (optional)

---

**Next Steps:**
1. Import passwords from old password manager
2. Generate strong passwords for all accounts
3. Enable 2FA on important accounts
4. Set up automated backups
5. Share passwords with family via Organizations

**Congratulations! You now have complete control over your passwords! **
