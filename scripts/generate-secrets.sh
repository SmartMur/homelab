#!/bin/bash
# Script to generate secure random secrets for homelab services

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Homelab Secret Generator ===${NC}\n"

# Function to generate random string
generate_secret() {
    local length=${1:-32}
    openssl rand -base64 48 | tr -dc 'a-zA-Z0-9' | head -c "$length"
}

# Function to generate hex string
generate_hex() {
    local length=${1:-32}
    openssl rand -hex "$length"
}

# Function to generate JWT secret
generate_jwt() {
    openssl rand -base64 64 | tr -d '\n'
}

# Function to hash password with bcrypt
hash_password() {
    local password="$1"
    if command -v htpasswd &> /dev/null; then
        htpasswd -nbB "" "$password" | cut -d ":" -f 2
    else
        echo -e "${YELLOW}Warning: htpasswd not found. Install apache2-utils for bcrypt hashing${NC}"
        echo "$password"
    fi
}

echo "Select what to generate:"
echo "1) Single secret (32 chars)"
echo "2) Long secret (64 chars)"
echo "3) JWT/Encryption key"
echo "4) Database password"
echo "5) API token (hex)"
echo "6) Bcrypt password hash"
echo "7) Complete set for a service"
echo ""
read -p "Choice [1-7]: " choice

case $choice in
    1)
        echo -e "\n${GREEN}Generated Secret (32 chars):${NC}"
        generate_secret 32
        echo ""
        ;;
    2)
        echo -e "\n${GREEN}Generated Secret (64 chars):${NC}"
        generate_secret 64
        echo ""
        ;;
    3)
        echo -e "\n${GREEN}Generated JWT/Encryption Key:${NC}"
        generate_jwt
        echo ""
        ;;
    4)
        echo -e "\n${GREEN}Generated Database Password:${NC}"
        generate_secret 32
        echo ""
        ;;
    5)
        echo -e "\n${GREEN}Generated API Token (hex):${NC}"
        generate_hex 32
        echo ""
        ;;
    6)
        read -sp "Enter password to hash: " password
        echo ""
        echo -e "\n${GREEN}Bcrypt Hash:${NC}"
        hash_password "$password"
        echo ""
        ;;
    7)
        echo -e "\n${GREEN}Complete Service Secret Set:${NC}"
        echo "---"
        echo "DB_PASSWORD=$(generate_secret 32)"
        echo "SECRET_KEY=$(generate_secret 64)"
        echo "JWT_SECRET=$(generate_jwt)"
        echo "ENCRYPTION_KEY=$(generate_secret 64)"
        echo "API_TOKEN=$(generate_hex 32)"
        echo "---"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "${YELLOW}Remember: Never commit these secrets to git!${NC}"
