#!/bin/bash
# Script to setup .env files from .env.example templates

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Setting up .env files from templates ===${NC}\n"

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

echo -e "\n${GREEN}Created $count .env files${NC}"
echo -e "${YELLOW}Remember to edit these files with your actual secrets!${NC}"
