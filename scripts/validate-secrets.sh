#!/bin/bash
# Script to validate that secrets are properly configured

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Secrets Validation Tool ===${NC}\n"

errors=0
warnings=0

# Function to check if a file contains CHANGE_ME placeholders
check_file_for_placeholders() {
    local file="$1"
    if [ -f "$file" ]; then
        if grep -q "CHANGE_ME" "$file"; then
            echo -e "${YELLOW}WARNING: $file contains CHANGE_ME placeholders${NC}"
            ((warnings++))
        else
            echo -e "${GREEN}✓ $file - configured${NC}"
        fi
    fi
}

# Function to check if .env file exists
check_env_exists() {
    local dir="$1"
    local env_file="$dir/.env"
    local example_file="$dir/.env.example"
    
    if [ -f "$example_file" ]; then
        if [ ! -f "$env_file" ]; then
            echo -e "${RED}ERROR: Missing $env_file (template exists at $example_file)${NC}"
            ((errors++))
        else
            check_file_for_placeholders "$env_file"
        fi
    fi
}

# Function to check if sensitive files are gitignored
check_gitignore() {
    local file="$1"
    if [ -f "$file" ] && ! git check-ignore -q "$file"; then
        echo -e "${RED}ERROR: $file is NOT in .gitignore!${NC}"
        ((errors++))
        return 1
    fi
    return 0
}

echo "Checking for .env files..."
while IFS= read -r -d '' example_file; do
    dir=$(dirname "$example_file")
    check_env_exists "$dir"
done < <(find . -name ".env.example" -type f -print0)

echo -e "\nChecking critical configuration files..."

# Check Authelia
if [ -f "Authelia/Authelia/configuration.yml" ]; then
    check_file_for_placeholders "Authelia/Authelia/configuration.yml"
    check_gitignore "Authelia/Authelia/configuration.yml"
fi

if [ -f "Authelia/Authelia/users_database.yml" ]; then
    check_file_for_placeholders "Authelia/Authelia/users_database.yml"
    check_gitignore "Authelia/Authelia/users_database.yml"
fi

# Check for exposed secrets
echo -e "\nChecking for exposed secret files..."
sensitive_patterns=("password" "access_token" "cf-token" "cloudflare.ini" "credentials.yaml")

for pattern in "${sensitive_patterns[@]}"; do
    while IFS= read -r -d '' file; do
        # Skip .example files
        if [[ "$file" == *.example ]]; then
            continue
        fi
        
        if [ -f "$file" ]; then
            if ! check_gitignore "$file"; then
                echo -e "${RED}ERROR: Sensitive file $file is not gitignored!${NC}"
                ((errors++))
            fi
        fi
    done < <(find . -name "*$pattern*" -type f -print0 2>/dev/null)
done

# Summary
echo -e "\n${GREEN}=== Validation Summary ===${NC}"
echo -e "Errors: ${RED}$errors${NC}"
echo -e "Warnings: ${YELLOW}$warnings${NC}"

if [ $errors -gt 0 ]; then
    echo -e "\n${RED}Validation FAILED! Please fix the errors above.${NC}"
    exit 1
elif [ $warnings -gt 0 ]; then
    echo -e "\n${YELLOW}Validation passed with warnings. Please review.${NC}"
    exit 0
else
    echo -e "\n${GREEN}All validations passed!${NC}"
    exit 0
fi
