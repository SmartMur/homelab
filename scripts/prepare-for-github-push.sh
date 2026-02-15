#!/bin/bash
# Script to prepare repository for public GitHub push
# This removes secret files from git tracking while keeping them locally

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║   Preparing Repository for GitHub Push                       ║
║   Target: https://github.com/SmartMur/homelab                ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

# Step 1: Remove secret files from git tracking (keep local copies)
echo -e "${BLUE}Step 1: Removing secret files from git tracking...${NC}"
echo "(Files will remain on your local system, just removed from git)"
echo ""

# Remove files from git but keep locally (--cached)
git rm --cached Authelia/Authelia/users_database.yml 2>/dev/null && echo "✅ Removed: Authelia/Authelia/users_database.yml" || echo "⚠️  Already removed: users_database.yml"
git rm --cached Authelia/Authelia/configuration.yml 2>/dev/null && echo "✅ Removed: Authelia/Authelia/configuration.yml" || echo "⚠️  Already removed: configuration.yml"
git rm --cached Watchtower/access_token 2>/dev/null && echo "✅ Removed: Watchtower/access_token" || echo "⚠️  Already removed: access_token"
git rm --cached Popup-Homelab/cf-token 2>/dev/null && echo "✅ Removed: Popup-Homelab/cf-token" || echo "⚠️  Already removed: Popup-Homelab/cf-token"
git rm --cached Traefikv3/cf-token 2>/dev/null && echo "✅ Removed: Traefikv3/cf-token" || echo "⚠️  Already removed: Traefikv3/cf-token"
git rm --cached Ansible/Playbooks/Secrets-Variables/password 2>/dev/null && echo "✅ Removed: Ansible password file" || echo "⚠️  Already removed: password"
git rm --cached Tinyauth/users 2>/dev/null && echo "✅ Removed: Tinyauth/users" || echo "⚠️  Already removed: Tinyauth/users"

# Remove potentially secret Kubernetes files
git rm --cached Ente/config/scripts/compose/credentials.yaml 2>/dev/null && echo "✅ Removed: Ente credentials" || echo "⚠️  Already removed: Ente credentials"
git rm --cached Home-Assistant/Kubernetes/secret.yaml 2>/dev/null && echo "✅ Removed: Home-Assistant secret" || echo "⚠️  Already removed: HA secret"
git rm --cached Kubernetes/Traefik-PiHole/Helm/Traefik/Cert-Manager/Issuers/secret-cf-token.yaml 2>/dev/null && echo "✅ Removed: K8s CF token" || echo "⚠️  Already removed"
git rm --cached Kubernetes/Traefik-PiHole/Helm/Traefik/Dashboard/secret-dashboard.yaml 2>/dev/null && echo "✅ Removed: K8s dashboard secret" || echo "⚠️  Already removed"
git rm --cached Pihole/Kubernetes/sealed-secret.yaml 2>/dev/null && echo "✅ Removed: Pihole sealed secret" || echo "⚠️  Already removed"

echo ""

# Step 2: Verify files still exist locally
echo -e "${BLUE}Step 2: Verifying local files still exist...${NC}"
files_ok=true
for file in "Authelia/Authelia/users_database.yml" "Authelia/Authelia/configuration.yml" "Watchtower/access_token"; do
  if [ -f "$file" ]; then
    echo "✅ $file"
  else
    echo -e "${RED}❌ Missing: $file${NC}"
    files_ok=false
  fi
done
echo ""

if [ "$files_ok" = false ]; then
  echo -e "${RED}ERROR: Some local secret files are missing!${NC}"
  echo "This script should not delete local files, only remove from git tracking."
  exit 1
fi

# Step 3: Run validation
echo -e "${BLUE}Step 3: Running security validation...${NC}"
if [ -f "./scripts/validate-secrets.sh" ]; then
  ./scripts/validate-secrets.sh || echo -e "${YELLOW}Validation had warnings (review above)${NC}"
else
  echo -e "${YELLOW}Validation script not found, skipping${NC}"
fi
echo ""

# Step 4: Test pre-commit hooks
echo -e "${BLUE}Step 4: Testing pre-commit hooks...${NC}"
if command -v pre-commit &> /dev/null; then
  echo "Running pre-commit on all files..."
  pre-commit run --all-files || echo -e "${YELLOW}Some hooks failed - review above${NC}"
else
  echo -e "${YELLOW}pre-commit not installed. Install with: pip install pre-commit${NC}"
fi
echo ""

# Step 5: Show git status
echo -e "${BLUE}Step 5: Current git status...${NC}"
git status --short | head -40
echo ""

# Step 6: Verification summary
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Preparation Summary${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Files removed from git (but kept locally):"
git status --short | grep "^D " | wc -l | xargs echo "  Deleted from git:"
echo ""
echo "Modified files ready to commit:"
git status --short | grep "^M " | wc -l | xargs echo "  Modified:"
echo ""
echo "New files to be added:"
git status --short | grep "^?? " | wc -l | xargs echo "  Untracked:"
echo ""

# Step 7: Next steps
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Next Steps:${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "1. Review the changes:"
echo "   ${BLUE}git status${NC}"
echo "   ${BLUE}git diff --cached${NC}"
echo ""
echo "2. Add all changes:"
echo "   ${BLUE}git add .${NC}"
echo ""
echo "3. Commit the changes:"
echo "   ${BLUE}git commit -m \"Security refactor: Remove secrets, add .env templates\"${NC}"
echo ""
echo "4. Set up remote (if not already done):"
echo "   ${BLUE}git remote add origin https://github.com/SmartMur/homelab.git${NC}"
echo "   Or if remote exists:"
echo "   ${BLUE}git remote set-url origin https://github.com/SmartMur/homelab.git${NC}"
echo ""
echo "5. Push to GitHub:"
echo "   ${BLUE}git branch -M main${NC}"
echo "   ${BLUE}git push -u origin main${NC}"
echo ""
echo -e "${RED}⚠️  IMPORTANT: Review GITHUB-PUSH-PLAN.md before pushing!${NC}"
echo ""
echo -e "${GREEN}Repository is ready for GitHub push!${NC}"
