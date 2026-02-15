# Traefik v3 - Reverse Proxy & SSL Manager


## What is Traefik?

Traefik is a modern reverse proxy and load balancer that makes it easy to deploy and manage your services with automatic HTTPS.

**Think of Traefik as:**
- A receptionist directing visitors to the right office
- An automatic SSL certificate manager
- A single entry point for all your services

**Instead of:**
```
http://192.168.1.100:8096 # Jellyfin
http://192.168.1.100:8080 # Portainer
http://192.168.1.100:3000 # Gitea
```

**You get:**
```
https://jellyfin.yourdomain.com
https://portainer.yourdomain.com
https://gitea.yourdomain.com
```

## Why You Need This

- **Automatic HTTPS** - Free SSL certificates from Let's Encrypt
- **Nice URLs** - Use subdomains instead of IP:port
- **Single Entry Point** - One place to manage all services
- **Auto-Discovery** - Reads Docker labels, no manual config
- **Load Balancing** - Distribute traffic across multiple instances

**This should be one of your FIRST services!**

## Prerequisites

### Required
- [ ] Domain name (e.g., from Cloudflare, Namecheap - $10-15/year)
- [ ] Domain DNS pointing to your server IP
- [ ] Docker & Docker Compose installed
- [ ] Ports 80 and 443 available (or forwarded from router)

### Optional but Recommended
- [ ] Cloudflare account (for DNS challenge)
- [ ] Email address (for Let's Encrypt notifications)

## Quick Start

### 1. Get Your Domain Ready

**Option A: Using Cloudflare (Recommended)**
1. Sign up at cloudflare.com
2. Add your domain
3. Update nameservers at your registrar
4. Create API token:
 - Go to: My Profile → API Tokens
 - Create Token → Edit Zone DNS
 - Zone Resources: Include → Specific Zone → yourdomain.com
 - Copy the token

**Option B: Direct DNS**
1. Point A record to your public IP
2. Point wildcard *.yourdomain.com to your public IP

### 2. Clone and Configure

```bash
# Navigate to Traefik directory
cd Traefikv3

# Copy example environment file
cp .env.example .env

# Edit configuration
nano .env
```

### 3. Configure .env File

```bash
# Required Settings
DOMAIN=yourdomain.com # Your domain
EMAIL=your-email@example.com # For Let's Encrypt

# Cloudflare Settings (if using Cloudflare)
CF_API_TOKEN=your_cloudflare_api_token # From Cloudflare dashboard

# Dashboard Access (Change these!)
TRAEFIK_DASHBOARD_USER=admin
TRAEFIK_DASHBOARD_PASSWORD=changeme123 # Use strong password!

# Optional: Network
TRAEFIK_NETWORK=traefik # Docker network name
```

### 4. Deploy

```bash
# Start Traefik
docker compose up -d

# Check logs
docker compose logs -f

# Verify it's running
docker ps | grep traefik
```

### 5. Access Dashboard

1. Open browser
2. Go to: `https://traefik.yourdomain.com`
3. Login with credentials from .env
4. You should see the Traefik dashboard!

Done. Traefik is now running and managing SSL certificates automatically.

## File Structure

```
Traefikv3/
 docker-compose.yaml # Main configuration
 .env # Your secrets (gitignored)
 .env.example # Template to copy
 config/
 traefik.yaml # Traefik configuration
 acme/ # SSL certificates (auto-generated)
 README.md # This file
```

## Configuration Explained

### docker-compose.yaml

```yaml
services:
 traefik:
 image: traefik:v3.0
 container_name: traefik
 restart: unless-stopped
 
 # Expose HTTP and HTTPS
 ports:
 - "80:80" # HTTP
 - "443:443" # HTTPS
 
 # Mount Docker socket (to read labels)
 volumes:
 - /var/run/docker.sock:/var/run/docker.sock:ro
 - ./config/traefik.yaml:/etc/traefik/traefik.yaml
 - ./acme:/acme
 
 # Network
 networks:
 - traefik
 
 # Labels for dashboard
 labels:
 - "traefik.enable=true"
 - "traefik.http.routers.dashboard.rule=Host(`traefik.${DOMAIN}`)"
 - "traefik.http.routers.dashboard.service=api@internal"
```

### Key Concepts

**Routers** - Define how requests are routed
- `traefik.http.routers.myapp.rule=Host('app.domain.com')` - Match domain
- `traefik.http.routers.myapp.entrypoints=websecure` - Use HTTPS

**Services** - Define the backend
- `traefik.http.services.myapp.loadbalancer.server.port=8080` - Backend port

**Middlewares** - Modify requests
- Authentication, rate limiting, headers, etc.

## Adding Services to Traefik

To expose a service through Traefik, add labels to its docker-compose.yaml:

### Example: Exposing Jellyfin

```yaml
services:
 jellyfin:
 image: jellyfin/jellyfin
 container_name: jellyfin
 networks:
 - traefik # Must be on Traefik network
 labels:
 # Enable Traefik
 - "traefik.enable=true"
 
 # Router configuration
 - "traefik.http.routers.jellyfin.rule=Host(`jellyfin.${DOMAIN}`)"
 - "traefik.http.routers.jellyfin.entrypoints=websecure"
 - "traefik.http.routers.jellyfin.tls.certresolver=cloudflare"
 
 # Service configuration (which port)
 - "traefik.http.services.jellyfin.loadbalancer.server.port=8096"

networks:
 traefik:
 external: true
```

**That's it!** Jellyfin is now accessible at `https://jellyfin.yourdomain.com`

## Security Best Practices

### 1. Strong Dashboard Password

```bash
# Generate strong password
openssl rand -base64 32

# Update .env file
TRAEFIK_DASHBOARD_PASSWORD=your_generated_password
```

### 2. Restrict Dashboard Access

Add IP whitelist to dashboard:

```yaml
labels:
 - "traefik.http.routers.dashboard.middlewares=dashboard-auth,dashboard-ipwhitelist"
 - "traefik.http.middlewares.dashboard-ipwhitelist.ipwhitelist.sourcerange=192.168.1.0/24"
```

### 3. Use Cloudflare DNS Challenge

Advantages:
- No need to expose port 80
- Works behind CGNAT
- Wildcard certificates

Already configured in this setup!

### 4. Enable HTTP to HTTPS Redirect

Already configured - all HTTP traffic automatically redirects to HTTPS.

### 5. Security Headers

Add security headers middleware:

```yaml
labels:
 - "traefik.http.middlewares.security-headers.headers.sslRedirect=true"
 - "traefik.http.middlewares.security-headers.headers.stsSeconds=315360000"
 - "traefik.http.middlewares.security-headers.headers.browserXssFilter=true"
 - "traefik.http.middlewares.security-headers.headers.contentTypeNosniff=true"
```

## Troubleshooting

### Issue: "Bad Gateway" or "Service Unavailable"

**Check:**
```bash
# Is service running?
docker ps | grep service-name

# Is service on traefik network?
docker network inspect traefik

# Check Traefik logs
docker compose logs -f traefik

# Check service logs
docker compose -f /path/to/service/docker-compose.yaml logs -f
```

**Common causes:**
- Service not on `traefik` network
- Wrong port in labels
- Service not actually running

### Issue: SSL Certificate Not Working

**Check:**
```bash
# Check certificate generation
docker compose logs traefik | grep -i certificate

# Verify DNS is correct
nslookup jellyfin.yourdomain.com

# Check Cloudflare API token
# Should have DNS edit permissions
```

**Common causes:**
- Invalid Cloudflare API token
- DNS not propagated yet (wait 5-10 minutes)
- Email not set in .env
- Rate limit from Let's Encrypt (max 5 per week)

### Issue: Can't Access Dashboard

**Check:**
```bash
# Verify Traefik is running
docker ps | grep traefik

# Check DNS points to server
nslookup traefik.yourdomain.com

# Check logs for errors
docker compose logs -f traefik

# Verify credentials
echo $TRAEFIK_DASHBOARD_USER
echo $TRAEFIK_DASHBOARD_PASSWORD
```

### Issue: Port 80 or 443 Already in Use

**Check what's using the port:**
```bash
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443
```

**Common causes:**
- Apache/Nginx already running
- Another container using the port

**Solution:**
```bash
# Stop conflicting service
sudo systemctl stop apache2
sudo systemctl stop nginx

# Or remove conflicting container
docker stop container-name
```

## Monitoring

### View Traefik Dashboard

Access: `https://traefik.yourdomain.com`

**You can see:**
- All routers (services)
- HTTP requests in real-time
- Certificate status
- Middleware status
- Service health

### Check Logs

```bash
# Real-time logs
docker compose logs -f traefik

# Last 100 lines
docker compose logs --tail=100 traefik

# Search for errors
docker compose logs traefik | grep -i error
```

### Certificate Status

```bash
# List certificates
ls -la acme/

# View certificate details
cat acme/acme.json | jq
```

## Updating

```bash
# Pull latest image
docker compose pull

# Recreate container
docker compose up -d

# Check logs
docker compose logs -f
```

**Traefik updates automatically handle:**
- Certificate renewals (30 days before expiry)
- Service discovery
- Configuration reload

## Hard Configuration

### Wildcard Certificates

Already configured! Using Cloudflare DNS challenge enables wildcard certs:
- `*.yourdomain.com` - Covers all subdomains

### Custom Middlewares

Create reusable middlewares:

```yaml
# In traefik.yaml or via labels
http:
 middlewares:
 # Rate limiting
 rate-limit:
 rateLimit:
 average: 100
 burst: 50
 
 # CORS headers
 cors-headers:
 headers:
 accessControlAllowMethods: ["GET","POST","PUT"]
 accessControlAllowOriginList: ["https://yourdomain.com"]
```

### Multiple Domains

Support multiple domains:

```yaml
labels:
 - "traefik.http.routers.app.rule=Host(`app.domain1.com`) || Host(`app.domain2.com`)"
```

## Related Services

**Deploy these next:**
1. **Authelia** - Add 2FA to all services behind Traefik
2. **Watchtower** - Auto-update Traefik and other containers
3. **Uptime Kuma** - Monitor Traefik uptime

**Traefik works great with:**
- Any web service (Jellyfin, Nextcloud, etc.)
- Authentication layers (Authelia, Authentik)
- Monitoring tools (Grafana, Uptime Kuma)

## Tips & Tricks

### 1. Test with curl

```bash
# Test routing
curl -H "Host: jellyfin.yourdomain.com" http://localhost

# Test SSL
curl -I https://jellyfin.yourdomain.com
```

### 2. Temporary Disable Service

```bash
# Change label to disable
traefik.enable=false

# Recreate container
docker compose up -d
```

### 3. Debug Mode

Enable debug logging in `traefik.yaml`:

```yaml
log:
 level: DEBUG
```

### 4. Backup Certificates

```bash
# Backup acme.json (contains all certificates)
cp acme/acme.json acme/acme.json.backup
```

## Additional Resources

- [Official Traefik Docs](https://doc.traefik.io/traefik/)
- [Traefik + Docker Guide](https://doc.traefik.io/traefik/providers/docker/)
- [Let's Encrypt Rate Limits](https://letsencrypt.org/docs/rate-limits/)
- [Cloudflare API Tokens](https://developers.cloudflare.com/api/tokens/create)

## Getting Help

**Before asking for help, collect:**
1. Traefik logs: `docker compose logs traefik`
2. Service logs: `docker compose logs service-name`
3. Your docker-compose.yaml (remove secrets!)
4. DNS configuration (output of `nslookup subdomain.domain.com`)

**Ask in:**
- r/selfhosted
- r/homelab
- Traefik Discord
- GitHub Issues

## Success Checklist

After setup, verify:

- [ ] Traefik dashboard accessible at https://traefik.yourdomain.com
- [ ] SSL certificate is valid (green padlock in browser)
- [ ] Can add services with labels and access them
- [ ] HTTP automatically redirects to HTTPS
- [ ] Dashboard requires authentication
- [ ] Certificates auto-renew (check acme/acme.json)

---

**Next Steps:**
1. Deploy Authelia to add 2FA
2. Add your first service (Portainer, Jellyfin, etc.)
3. Set up monitoring with Uptime Kuma

**Traefik is your homelab's front door - configure it well and everything else becomes easier!** 
