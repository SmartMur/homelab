#!/bin/bash
# Core Services Deployment Script
# Deploys: Traefik, Pi-hole, Authelia, Vaultwarden, Portainer, Watchtower

set -e

echo "=========================================="
echo "   Homelab Core Services Deployment"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Error: Do not run as root${NC}"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    echo "Run: curl -fsSL https://get.docker.com | sh"
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed${NC}"
    echo "Run: sudo apt install git -y"
    exit 1
fi

# Get user inputs
echo -e "${YELLOW}Enter your domain name (e.g., example.com):${NC}"
read -r DOMAIN

echo -e "${YELLOW}Enter your email for SSL certificates:${NC}"
read -r EMAIL

echo -e "${YELLOW}Enter Cloudflare API token (or press Enter to skip):${NC}"
read -r CF_TOKEN

echo ""
echo "=========================================="
echo "Starting deployment..."
echo "=========================================="
echo ""

# Clone repo if not exists
if [ ! -d "$HOME/homelab" ]; then
    echo -e "${GREEN}Cloning homelab repository...${NC}"
    cd "$HOME"
    git clone https://github.com/SmartMur/homelab.git
fi

cd "$HOME/homelab"

# Create Docker network
echo -e "${GREEN}Creating Docker network...${NC}"
docker network create traefik 2>/dev/null || echo "Network already exists"

# Deploy Traefik
echo -e "${GREEN}Deploying Traefik...${NC}"
cd Traefikv3
if [ ! -f .env ]; then
    cp .env.example .env
    sed -i "s/DOMAIN=.*/DOMAIN=$DOMAIN/" .env
    sed -i "s/EMAIL=.*/EMAIL=$EMAIL/" .env
    if [ -n "$CF_TOKEN" ]; then
        sed -i "s/CF_API_TOKEN=.*/CF_API_TOKEN=$CF_TOKEN/" .env
    fi
fi
docker compose up -d
echo -e "${GREEN}Traefik deployed!${NC}"
sleep 5

# Deploy Pi-hole
echo -e "${GREEN}Deploying Pi-hole...${NC}"
cd "$HOME/homelab/Pihole"
docker compose up -d
sleep 3
PIHOLE_PASSWORD=$(docker logs pihole 2>&1 | grep "random password" | awk '{print $NF}')
echo -e "${YELLOW}Pi-hole admin password: $PIHOLE_PASSWORD${NC}"
echo "$PIHOLE_PASSWORD" > "$HOME/pihole-password.txt"
echo -e "${GREEN}Pi-hole deployed!${NC}"
sleep 5

# Deploy Vaultwarden
echo -e "${GREEN}Deploying Vaultwarden...${NC}"
cd "$HOME/homelab/Vaultwarden"
docker compose up -d
echo -e "${GREEN}Vaultwarden deployed!${NC}"
sleep 5

# Deploy Portainer
echo -e "${GREEN}Deploying Portainer...${NC}"
cd "$HOME/homelab/Portainer"
docker compose up -d
echo -e "${GREEN}Portainer deployed!${NC}"
sleep 5

# Deploy Watchtower
echo -e "${GREEN}Deploying Watchtower...${NC}"
cd "$HOME/homelab/Watchtower"
if [ ! -f .env ]; then
    cp .env.example .env
fi
docker compose up -d
echo -e "${GREEN}Watchtower deployed!${NC}"

echo ""
echo "=========================================="
echo "   Deployment Complete!"
echo "=========================================="
echo ""
echo -e "${GREEN}Core services deployed successfully!${NC}"
echo ""
echo "Access your services:"
echo "  - Traefik:     https://traefik.$DOMAIN"
echo "  - Pi-hole:     http://$(hostname -I | awk '{print $1}')/admin"
echo "  - Vaultwarden: https://vault.$DOMAIN"
echo "  - Portainer:   https://portainer.$DOMAIN"
echo ""
echo "Pi-hole password saved to: $HOME/pihole-password.txt"
echo ""
echo "Next steps:"
echo "  1. Configure DNS to point to your server"
echo "  2. Set up Authelia for 2FA (see PROXMOX-DEPLOYMENT.md)"
echo "  3. Deploy additional services as needed"
echo ""
echo "Check status: docker ps"
echo ""
