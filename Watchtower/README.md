# Watchtower - Automated Docker Container Updates

Watchtower automatically updates running Docker containers when new images are available.

## Quick Start

### 1. Setup Environment File
```bash
cp .env.example .env
```

### 2. Generate API Token
```bash
# Generate secure token
openssl rand -base64 32

# Add to .env file
WATCHTOWER_HTTP_API_TOKEN=your_generated_token
```

### 3. Configure Schedule (Optional)
Edit `.env` to customize update schedule (cron format):
```
WATCHTOWER_SCHEDULE=0 0 4 * * *  # Daily at 4 AM
```

### 4. Start Watchtower
```bash
docker-compose up -d
```

## Configuration

### Environment Variables (.env)

- `WATCHTOWER_HTTP_API_TOKEN` - Secure token for HTTP API access
- `WATCHTOWER_SCHEDULE` - Cron schedule for updates (default: 4 AM daily)
- `TZ` - Timezone for scheduling

### Optional Features

**Exclude Specific Containers:**
```bash
# In docker-compose.yaml environment section:
- WATCHTOWER_DISABLE_CONTAINERS=traefik,database,critical-app
```

**Monitor Only (No Auto-Updates):**
```bash
- WATCHTOWER_MONITOR_ONLY=true
```

**Include Stopped Containers:**
```bash
- WATCHTOWER_INCLUDE_STOPPED=true
- WATCHTOWER_REVIVE_STOPPED=true
```

## Notifications

### Gotify
```bash
# In .env:
WATCHTOWER_NOTIFICATIONS=gotify
WATCHTOWER_NOTIFICATION_URL=https://gotify.example.com/message?token=YOUR_TOKEN
```

### Email
```bash
WATCHTOWER_NOTIFICATIONS=email
WATCHTOWER_NOTIFICATION_EMAIL_FROM=watchtower@smartmur.lab
WATCHTOWER_NOTIFICATION_EMAIL_TO=admin@smartmur.lab
```

### Other Services
Supports: Slack, Discord, Teams, Pushover, Shoutrrr
See: https://containrrr.dev/watchtower/notifications/

## Manual Update Trigger

Enable HTTP API in docker-compose.yaml:
```yaml
ports:
  - "8080:8080"
```

Trigger update:
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:8080/v1/update
```

## Security Best Practices

1. ✅ **Never commit `.env` or `access_token`** to git
2. ✅ **Use strong API token** (minimum 32 characters)
3. ✅ **Mount docker.sock as read-only** (`:ro`)
4. ✅ **Use label-based filtering** for granular control:
   ```yaml
   # On containers you DON'T want updated:
   labels:
     - "com.centurylinklabs.watchtower.enable=false"
   ```

## Per-Container Control

Add labels to containers to control Watchtower behavior:

**Disable updates for a container:**
```yaml
labels:
  - "com.centurylinklabs.watchtower.enable=false"
```

**Custom update schedule:**
```yaml
labels:
  - "com.centurylinklabs.watchtower.enable=true"
  - "com.centurylinklabs.watchtower.schedule=0 0 2 * * *"
```

## Troubleshooting

### Check logs
```bash
docker-compose logs -f watchtower
```

### Test without updating
```bash
# Add to environment:
- WATCHTOWER_RUN_ONCE=true
- WATCHTOWER_MONITOR_ONLY=true
```

### Common Issues

**Container not updating:**
- Check if image has newer version
- Verify container not in WATCHTOWER_DISABLE_CONTAINERS
- Check container doesn't have `enable=false` label

**Permission errors:**
- Ensure docker.sock is mounted
- Check container user permissions

## Resources

- [Official Documentation](https://containrrr.dev/watchtower/)
- [Configuration Reference](https://containrrr.dev/watchtower/arguments/)
- [Notification Guide](https://containrrr.dev/watchtower/notifications/)
