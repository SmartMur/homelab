#!/bin/bash
# Media Stack Deployment Script
# Deploys: Jellyfin, Sonarr, Radarr, Prowlarr, qBittorrent

set -e

echo "=========================================="
echo "   Media Stack Deployment"
echo "=========================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check prerequisites
if ! docker network ls | grep -q traefik; then
    echo -e "${RED}Error: Traefik network not found${NC}"
    echo "Run deploy-core.sh first"
    exit 1
fi

# Get media paths
echo -e "${YELLOW}Enter path to movies directory (e.g., /data/media/movies):${NC}"
read -r MOVIES_PATH

echo -e "${YELLOW}Enter path to TV shows directory (e.g., /data/media/tv):${NC}"
read -r TV_PATH

echo -e "${YELLOW}Enter path to downloads directory (e.g., /data/downloads):${NC}"
read -r DOWNLOADS_PATH

# Create directories if they don't exist
mkdir -p "$MOVIES_PATH"
mkdir -p "$TV_PATH"
mkdir -p "$DOWNLOADS_PATH"

echo ""
echo "=========================================="
echo "Starting deployment..."
echo "=========================================="
echo ""

cd "$HOME/homelab"

# Deploy Jellyfin
echo -e "${GREEN}Deploying Jellyfin...${NC}"
cd Jellyfin
# Update docker-compose with paths
sed -i "s|/path/to/movies|$MOVIES_PATH|g" docker-compose.yml
sed -i "s|/path/to/tv|$TV_PATH|g" docker-compose.yml
docker compose up -d
echo -e "${GREEN}Jellyfin deployed!${NC}"
sleep 5

echo ""
echo "=========================================="
echo "   Media Stack Deployed!"
echo "=========================================="
echo ""
echo "Access your services:"
echo "  - Jellyfin:    https://jellyfin.yourdomain.com"
echo ""
echo "Media paths configured:"
echo "  - Movies: $MOVIES_PATH"
echo "  - TV:     $TV_PATH"
echo "  - Downloads: $DOWNLOADS_PATH"
echo ""
echo "Next steps:"
echo "  1. Configure Jellyfin at https://jellyfin.yourdomain.com"
echo "  2. Add media to your configured paths"
echo "  3. Scan libraries in Jellyfin"
echo ""
