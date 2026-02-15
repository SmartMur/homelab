# Network Architecture & Diagrams

Visual guides showing how everything connects in your homelab.

## Network Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                          INTERNET                                    │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             │ Port Forwarding (80, 443)
                             │
                    ┌────────▼────────┐
                    │  Your Router    │
                    │  192.168.1.1    │
                    └────────┬────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
      ┌─────▼─────┐    ┌────▼────┐    ┌─────▼──────┐
      │  Pi-hole  │    │ Traefik │    │ WireGuard  │
      │    DNS    │    │  Proxy  │    │    VPN     │
      │  :53      │    │ :80,:443│    │   :51820   │
      └───────────┘    └────┬────┘    └────────────┘
                            │
                            │ Docker Network
                            │
       ┌────────────────────┼────────────────────┐
       │                    │                    │
  ┌────▼─────┐        ┌────▼─────┐        ┌────▼─────┐
  │ Authelia │        │ Services │        │ Services │
  │   2FA    │        │  (Auth)  │        │ (Public) │
  │  :9091   │        │          │        │          │
  └──────────┘        └────┬─────┘        └──────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   ┌────▼────┐      ┌─────▼─────┐     ┌─────▼──────┐
   │Jellyfin │      │ Nextcloud │     │Vaultwarden │
   │  :8096  │      │   :443    │     │   :80      │
   └─────────┘      └───────────┘     └────────────┘
```

## Service Stack Layers

```
┌──────────────────────────────────────────────────────┐
│                  Layer 4: Apps                        │
│  Jellyfin │ Nextcloud │ Gitea │ Home Assistant │...  │
└──────────────────────────────────────────────────────┘
                         │
┌──────────────────────────────────────────────────────┐
│              Layer 3: Authentication                  │
│         Authelia (2FA) │ Vaultwarden (SSO)           │
└──────────────────────────────────────────────────────┘
                         │
┌──────────────────────────────────────────────────────┐
│              Layer 2: Reverse Proxy                   │
│        Traefik (SSL, Routing, Load Balancing)        │
└──────────────────────────────────────────────────────┘
                         │
┌──────────────────────────────────────────────────────┐
│           Layer 1: Network & Infrastructure           │
│     Pi-hole (DNS) │ WireGuard (VPN) │ Watchtower     │
└──────────────────────────────────────────────────────┘
                         │
┌──────────────────────────────────────────────────────┐
│                  Layer 0: Platform                    │
│            Docker │ Proxmox │ Bare Metal              │
└──────────────────────────────────────────────────────┘
```

## Data Flow Examples

### 1. External User Accessing Jellyfin

```
[User Phone/Laptop] 
    │
    │ HTTPS Request: jellyfin.yourdomain.com
    ▼
[Cloudflare CDN] (optional)
    │
    ▼
[Your Router:443]
    │
    ▼
[Traefik Container]
    │ Checks SSL Certificate
    │ Routes based on domain
    ▼
[Authelia Container]
    │ Requires login + 2FA
    │ Creates session cookie
    ▼
[Jellyfin Container:8096]
    │ Serves media
    ▼
[User sees movies/TV]
```

### 2. Internal Network Request

```
[Your Laptop on WiFi]
    │
    │ Query: jellyfin.local
    ▼
[Pi-hole:53]
    │ Resolves to 192.168.1.100
    ▼
[Traefik:443]
    │ Already logged in (cookie)
    ▼
[Jellyfin:8096]
    │
    ▼
[Stream starts instantly]
```

### 3. Remote Access via VPN

```
[Phone away from home]
    │
    │ Connect to WireGuard
    ▼
[WireGuard Server:51820]
    │ Creates encrypted tunnel
    │ Gives phone 10.0.0.2 IP
    ▼
[Phone is now "on home network"]
    │
    │ Access http://192.168.1.100:8096
    ▼
[All services accessible]
    │ No port forwarding needed
    │ Full security
```

## Docker Network Topology

```
┌─────────────────────────────────────────────────────────┐
│               Docker Host (Your Server)                  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │          traefik Network (bridge)                 │  │
│  │                                                    │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐       │  │
│  │  │ Traefik  │  │ Authelia │  │ Jellyfin │       │  │
│  │  │          │  │          │  │          │       │  │
│  │  └──────────┘  └──────────┘  └──────────┘       │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │        nextcloud-net Network (internal)           │  │
│  │                                                    │  │
│  │  ┌──────────┐  ┌──────────┐                      │  │
│  │  │Nextcloud │  │ Database │                      │  │
│  │  │          │  │          │                      │  │
│  │  └──────────┘  └──────────┘                      │  │
│  └──────────────────────────────────────────────────┘  │
│                                                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │             host Network                          │  │
│  │                                                    │  │
│  │  ┌──────────┐  ┌──────────┐                      │  │
│  │  │ Pi-hole  │  │WireGuard │                      │  │
│  │  │  :53     │  │  :51820  │                      │  │
│  │  └──────────┘  └──────────┘                      │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## Typical Homelab Setups

### Minimal Setup (Starter)

```
Hardware: Raspberry Pi 4 (4GB) or old laptop
Services: 5-10 lightweight

┌─────────────────┐
│   Single Host   │
│                 │
│  - Traefik      │
│  - Pi-hole      │
│  - Portainer    │
│  - Vaultwarden  │
│  - Uptime Kuma  │
└─────────────────┘

Total RAM: 4GB
Total CPU: 2 cores
Total Storage: 32GB
Power: ~10W
Cost: $5-10/month
```

### Recommended Setup (Most Users)

```
Hardware: Intel NUC or Mini PC
Services: 20-30 services

┌─────────────────────────────┐
│     Single Host (NUC)       │
│                             │
│  Core Services:             │
│  - Traefik                  │
│  - Authelia                 │
│  - Pi-hole                  │
│  - WireGuard                │
│                             │
│  Applications:              │
│  - Jellyfin                 │
│  - Nextcloud                │
│  - Vaultwarden              │
│  - Gitea                    │
│  - Home Assistant           │
│                             │
│  Management:                │
│  - Portainer                │
│  - Uptime Kuma              │
│  - Watchtower               │
└─────────────────────────────┘

Total RAM: 16GB
Total CPU: 4 cores
Total Storage: 256GB SSD + 1TB HDD
Power: ~25W
Cost: $10-15/month
```

### Advanced Setup (Proxmox Cluster)

```
Hardware: 3x servers or workstations
Services: Unlimited

┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   Proxmox 1     │  │   Proxmox 2     │  │   Proxmox 3     │
│                 │  │                 │  │                 │
│  VM: Services   │  │  VM: Media      │  │  VM: Storage    │
│  - Traefik      │  │  - Jellyfin     │  │  - Nextcloud    │
│  - Authelia     │  │  - Sonarr       │  │  - Databases    │
│  - Pi-hole      │  │  - Radarr       │  │  - Backups      │
│                 │  │  - qBittorrent  │  │                 │
│  VM: K8s Master │  │  VM: K8s Worker │  │  VM: K8s Worker │
│  - Control      │  │  - Workloads    │  │  - Workloads    │
│    Plane        │  │                 │  │                 │
└────────┬────────┘  └────────┬────────┘  └────────┬────────┘
         │                    │                    │
         └────────────────────┴────────────────────┘
                        10Gb Network

Total RAM: 96GB (32GB each)
Total CPU: 24 cores (8 each)
Total Storage: 2TB NVMe + 12TB HDD
Power: ~150W
Cost: $20-30/month
```

## Port Reference Guide

Common ports used in homelab setups:

```
External Ports (Forwarded from Router):
├─ 80   → Traefik (HTTP, redirects to 443)
├─ 443  → Traefik (HTTPS)
└─ 51820→ WireGuard (VPN)

Internal Service Ports:
├─ 53   → Pi-hole (DNS)
├─ 80   → Nginx, Traefik dashboard
├─ 443  → SSL services
├─ 9000 → Portainer
├─ 9091 → Authelia
├─ 8080 → Various services
├─ 8096 → Jellyfin
├─ 3000 → Gitea, Grafana
├─ 5432 → PostgreSQL
├─ 3306 → MySQL/MariaDB
├─ 6379 → Redis
└─ 8123 → Home Assistant

Database Ports (Internal Only):
├─ 5432 → PostgreSQL
├─ 3306 → MySQL/MariaDB
├─ 27017→ MongoDB
└─ 6379 → Redis
```

## Storage Layout

Recommended directory structure:

```
/data/
├── docker/                 # Docker compose files
│   ├── traefik/
│   ├── pihole/
│   ├── jellyfin/
│   └── ...
│
├── config/                 # Service configs
│   ├── traefik/
│   ├── authelia/
│   └── ...
│
├── media/                  # Media files
│   ├── movies/
│   ├── tv/
│   ├── music/
│   └── photos/
│
├── backups/               # Backup storage
│   ├── daily/
│   ├── weekly/
│   └── monthly/
│
└── downloads/             # Temporary downloads
    ├── complete/
    └── incomplete/
```

## Draw.io Diagrams

For editable diagrams, see the `diagrams/` folder:

- `network-architecture.drawio` - Full network topology
- `docker-network.drawio` - Container networking
- `data-flow.drawio` - Traffic flow diagrams
- `proxmox-layout.drawio` - Proxmox VM structure

**To edit:**
1. Go to https://app.diagrams.net/
2. Open file from GitHub or download locally
3. Edit and export as PNG/SVG

## Next Steps

- See [PROXMOX-DEPLOYMENT.md](PROXMOX-DEPLOYMENT.md) for deploying on Proxmox
- See [HARDWARE-GUIDE.md](HARDWARE-GUIDE.md) for hardware recommendations
- See [QUICK-DEPLOY.md](QUICK-DEPLOY.md) for one-click deployment scripts
