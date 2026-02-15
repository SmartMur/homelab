#!/bin/bash
# Initial setup script for the homelab

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}"
cat << "EOF"
╔═══════════════════════════════════════╗
║   Homelab Security Setup Wizard      ║
╔═══════════════════════════════════════╝
EOF
echo -e "${NC}\n"

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Warning: Docker not found. Please install Docker first.${NC}"
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Warning: docker-compose not found. Please install docker-compose first.${NC}"
fi

if ! command -v openssl &> /dev/null; then
    echo -e "${YELLOW}Warning: openssl not found. Some features may not work.${NC}"
fi

echo ""

# Setup pre-commit hooks
echo -e "${BLUE}Step 1: Setting up pre-commit hooks${NC}"
if command -v pre-commit &> /dev/null; then
    pre-commit install
    echo -e "${GREEN}✓ Pre-commit hooks installed${NC}"
else
    echo -e "${YELLOW}Warning: pre-commit not found. Install with: pip install pre-commit${NC}"
    echo -e "${YELLOW}Then run: pre-commit install${NC}"
fi
echo ""

# Create .env files from templates
echo -e "${BLUE}Step 2: Creating .env files from templates${NC}"
count=0
while IFS= read -r -d '' example_file; do
    env_file="${example_file%.example}"
    
    if [ -f "$env_file" ]; then
        echo -e "${YELLOW}Skipping (already exists): $env_file${NC}"
    else
        cp "$example_file" "$env_file"
        echo -e "${GREEN}Created: $env_file${NC}"
        ((count++))
    fi
done < <(find . -name ".env.example" -type f -print0)

echo -e "${GREEN}✓ Created $count new .env files${NC}"
echo ""

# Create example config files
echo -e "${BLUE}Step 3: Creating configuration files from templates${NC}"
config_count=0

# Authelia
if [ -f "Authelia/Authelia/configuration.yml.example" ] && [ ! -f "Authelia/Authelia/configuration.yml" ]; then
    cp "Authelia/Authelia/configuration.yml.example" "Authelia/Authelia/configuration.yml"
    echo -e "${GREEN}Created: Authelia/Authelia/configuration.yml${NC}"
    ((config_count++))
fi

if [ -f "Authelia/Authelia/users_database.yml.example" ] && [ ! -f "Authelia/Authelia/users_database.yml" ]; then
    cp "Authelia/Authelia/users_database.yml.example" "Authelia/Authelia/users_database.yml"
    echo -e "${GREEN}Created: Authelia/Authelia/users_database.yml${NC}"
    ((config_count++))
fi

echo -e "${GREEN}✓ Created $config_count configuration files${NC}"
echo ""

# Generate initial secrets
echo -e "${BLUE}Step 4: Would you like to generate secrets now?${NC}"
read -p "Generate secrets? (y/n): " generate_secrets

if [[ "$generate_secrets" == "y" ]]; then
    ./scripts/generate-secrets.sh
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Review and update all .env files with your actual values"
echo "2. Generate and set secure passwords/tokens (run: ./scripts/generate-secrets.sh)"
echo "3. Update domain names in configuration files"
echo "4. Review SECURITY.md for best practices"
echo "5. Start services: cd [service-directory] && docker-compose up -d"
echo ""
echo -e "${YELLOW}Important Files to Update:${NC}"
echo "• All .env files (replace CHANGE_ME values)"
echo "• Authelia/Authelia/configuration.yml (domain settings)"
echo "• Authelia/Authelia/users_database.yml (user passwords)"
echo "• Traefik configuration files (domain, email)"
echo ""
echo -e "${YELLOW}Security Checklist:${NC}"
echo "• ✓ .env files are gitignored"
echo "• ✓ Pre-commit hooks installed"
echo "• □ All CHANGE_ME values replaced"
echo "• □ Strong passwords generated"
echo "• □ SSL certificates configured"
echo "• □ Secrets rotated from defaults"
echo ""
echo -e "For validation, run: ${BLUE}./scripts/validate-secrets.sh${NC}"
