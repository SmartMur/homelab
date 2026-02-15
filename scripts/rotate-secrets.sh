#!/bin/bash
# Script to help rotate secrets across services

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}=== Secret Rotation Helper ===${NC}\n"

# Function to generate new secret
generate_secret() {
    local length=${1:-32}
    openssl rand -base64 48 | tr -dc 'a-zA-Z0-9' | head -c "$length"
}

# Function to backup file
backup_file() {
    local file="$1"
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    if [ -f "$file" ]; then
        cp "$file" "$backup"
        echo -e "${GREEN}Backed up to: $backup${NC}"
    fi
}

echo "This tool helps you rotate secrets in your homelab."
echo "Always test in a development environment first!"
echo ""

PS3="Select service to rotate secrets: "
options=("Authelia" "Traefik" "Watchtower" "All Services" "Custom" "Exit")

select opt in "${options[@]}"; do
    case $opt in
        "Authelia")
            echo -e "\n${BLUE}Rotating Authelia secrets...${NC}"
            echo "New JWT Secret: $(generate_secret 64)"
            echo "New Session Secret: $(generate_secret 64)"
            echo "New Encryption Key: $(generate_secret 64)"
            echo "New Redis Password: $(generate_secret 32)"
            echo ""
            echo -e "${YELLOW}Update these in Authelia/Authelia/.env${NC}"
            echo -e "${YELLOW}Then restart: cd Authelia/Authelia && docker-compose restart${NC}"
            break
            ;;
        "Traefik")
            echo -e "\n${BLUE}Rotating Traefik secrets...${NC}"
            echo "New Cloudflare API Token: (Get from Cloudflare dashboard)"
            echo ""
            read -p "Generate new dashboard password? (y/n): " generate_pass
            if [[ "$generate_pass" == "y" ]]; then
                read -p "Enter new password: " new_pass
                echo "New htpasswd entry:"
                echo "$(htpasswd -nb admin "$new_pass")"
            fi
            break
            ;;
        "Watchtower")
            echo -e "\n${BLUE}Rotating Watchtower secrets...${NC}"
            echo "New HTTP API Token: $(generate_secret 32)"
            echo ""
            echo -e "${YELLOW}Update in Watchtower/.env${NC}"
            echo -e "${YELLOW}Then restart: cd Watchtower && docker-compose restart${NC}"
            break
            ;;
        "All Services")
            echo -e "\n${RED}WARNING: This will generate new secrets for ALL services!${NC}"
            read -p "Are you sure? (yes/no): " confirm
            if [[ "$confirm" == "yes" ]]; then
                echo -e "\n${GREEN}=== Generated Secrets ===${NC}\n"
                
                echo -e "${BLUE}Authelia:${NC}"
                echo "AUTHELIA_JWT_SECRET=$(generate_secret 64)"
                echo "AUTHELIA_SESSION_SECRET=$(generate_secret 64)"
                echo "AUTHELIA_STORAGE_ENCRYPTION_KEY=$(generate_secret 64)"
                echo "REDIS_PASSWORD=$(generate_secret 32)"
                echo ""
                
                echo -e "${BLUE}Watchtower:${NC}"
                echo "WATCHTOWER_HTTP_API_TOKEN=$(generate_secret 32)"
                echo ""
                
                echo -e "${BLUE}General:${NC}"
                echo "DB_PASSWORD=$(generate_secret 32)"
                echo "SECRET_KEY=$(generate_secret 64)"
                echo "API_TOKEN=$(generate_secret 32)"
                echo ""
                
                echo -e "${YELLOW}Save these secrets securely!${NC}"
            fi
            break
            ;;
        "Custom")
            read -p "Enter secret length (default 32): " length
            length=${length:-32}
            echo -e "\n${GREEN}Generated Secret:${NC}"
            generate_secret "$length"
            echo ""
            break
            ;;
        "Exit")
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done

echo -e "\n${YELLOW}Remember to:${NC}"
echo "1. Update all .env files with new secrets"
echo "2. Restart affected services"
echo "3. Test services are working"
echo "4. Keep backup of old secrets until confirmed working"
echo "5. Document the rotation in your changelog"
