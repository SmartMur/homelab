# Migration Guide - From Hardcoded Secrets to Secure Configuration

This guide helps you migrate from the old repository structure (with hardcoded secrets) to the new secure structure.

## ⚠️ Important: Before You Start

1. **Backup everything** - Make a complete backup of your current setup
2. **Test in dev first** - Don't migrate production directly
3. **Have rollback plan** - Know how to revert if needed
4. **Document your secrets** - Keep a secure record during migration

## 🔄 Migration Steps

### Step 1: Pull Latest Changes

```bash
# Backup your current repository
cp -r /path/to/homelab /path/to/homelab.backup

# Pull the new secure structure
git pull origin main
```

### Step 2: Extract Your Existing Secrets

Create a secure temporary file to store your current secrets:

```bash
# Create a secure temporary file
touch ~/migration-secrets.txt
chmod 600 ~/migration-secrets.txt
```

**Authelia Secrets:**
```bash
# Extract from old configuration.yml
grep "jwt_secret:" Authelia/Authelia/configuration.yml >> ~/migration-secrets.txt
grep "session.*secret:" Authelia/Authelia/configuration.yml >> ~/migration-secrets.txt
grep "encryption_key:" Authelia/Authelia/configuration.yml >> ~/migration-secrets.txt
```

**Other Services:**
Document secrets from:
- `Watchtower/access_token`
- `Nginx/cloudflare.ini`
- `DynamicDNS/config`
- `DynamicDNS/script.sh`
- Any other files with credentials

### Step 3: Run Setup Script

```bash
./scripts/init-homelab.sh
```

This creates all `.env` and config files from templates.

### Step 4: Populate New Configuration

**For Authelia:**
```bash
cd Authelia/Authelia

# Edit .env with your extracted secrets
vim .env

# Update these variables with secrets from step 2:
# AUTHELIA_JWT_SECRET=<your_old_jwt_secret>
# AUTHELIA_SESSION_SECRET=<your_old_session_secret>
# AUTHELIA_STORAGE_ENCRYPTION_KEY=<your_old_encryption_key>
```

**For Watchtower:**
```bash
cd Watchtower

# Get old token
OLD_TOKEN=$(cat access_token 2>/dev/null || echo "generate_new")

# Add to .env
echo "WATCHTOWER_HTTP_API_TOKEN=$OLD_TOKEN" >> .env
```

**For Traefik/Cloudflare:**
```bash
cd Traefikv3

# Extract from old cf-token file
OLD_CF_TOKEN=$(cat cf-token 2>/dev/null || echo "")

# Add to .env
vim .env
# Set: CF_API_TOKEN=<your_token>
```

### Step 5: Migrate User Databases

**Authelia users_database.yml:**
```bash
cd Authelia/Authelia

# If you have existing users, copy password hashes
# From old: users_database.yml
# To new: users_database.yml (created from template)

# Make sure to keep the same password hashes!
```

**Tinyauth users:**
```bash
cd Tinyauth

# Copy from old users file
# Preserve bcrypt hashes for existing users
```

### Step 6: Validate Migration

```bash
# Run validation script
./scripts/validate-secrets.sh

# Check no CHANGE_ME values remain
grep -r "CHANGE_ME" --include="*.env" .

# Verify gitignore working
git status --ignored | grep -E "(\.env$|password|token|secret)"
```

### Step 7: Test Services

Test each service one at a time:

```bash
# Test Authelia first (critical for auth)
cd Authelia/Authelia
docker-compose up -d
docker-compose logs -f

# Verify you can log in with existing users
# Check configuration: docker-compose exec authelia authelia validate-config

# Test other services
cd ../../Traefik
docker-compose up -d
# etc...
```

### Step 8: Remove Old Secret Files

**Only after confirming everything works:**

```bash
# These should now be gitignored, but remove originals
rm -f Watchtower/access_token
rm -f Nginx/cloudflare.ini
rm -f DynamicDNS/script.sh  # Use .example instead
rm -f DynamicDNS/config      # Use .example instead
rm -f Traefikv3/cf-token
rm -f Popup-Homelab/cf-token
# etc...

# Verify they're not in git
git status
```

### Step 9: Clean Git History (Optional but Recommended)

**⚠️ WARNING: This rewrites git history. Coordinate with team.**

If secrets were previously committed to git:

```bash
# Use BFG Repo-Cleaner or git-filter-repo
# See: https://rtyley.github.io/bfg-repo-cleaner/

# Example with BFG:
java -jar bfg.jar --delete-files access_token
java -jar bfg.jar --delete-files cf-token
java -jar bfg.jar --replace-text passwords.txt  # List of secrets to remove

git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

### Step 10: Rotate Exposed Secrets

**Critical:** If secrets were in git history, rotate them:

```bash
./scripts/rotate-secrets.sh

# For each service:
# 1. Generate new secrets
# 2. Update .env files
# 3. Restart services
# 4. Revoke old credentials at source (Cloudflare, etc.)
```

## 📋 Migration Checklist

- [ ] Backed up entire repository
- [ ] Extracted all existing secrets to secure location
- [ ] Ran `./scripts/init-homelab.sh`
- [ ] Populated all `.env` files with secrets
- [ ] Migrated user databases (preserved password hashes)
- [ ] Validated configuration (`./scripts/validate-secrets.sh`)
- [ ] Tested each service individually
- [ ] Verified authentication still works
- [ ] Removed old secret files
- [ ] Updated git to not track secrets
- [ ] (Optional) Cleaned git history
- [ ] Rotated any exposed secrets
- [ ] Documented new secret locations
- [ ] Updated team documentation
- [ ] Deleted secure temporary files

## 🔒 Post-Migration Security

After migration:

1. **Install pre-commit hooks:**
   ```bash
   pre-commit install
   ```

2. **Set up secret rotation schedule:**
   - Calendar reminder every 90 days
   - Document rotation procedure

3. **Backup encrypted secrets:**
   ```bash
   # Backup .env files (encrypted)
   tar -czf secrets-backup.tar.gz $(find . -name ".env")
   gpg -c secrets-backup.tar.gz
   rm secrets-backup.tar.gz
   ```

4. **Update documentation:**
   - Document where secrets are stored
   - Update runbooks with new procedures
   - Train team on new structure

## 🆘 Troubleshooting

### Service won't start after migration

```bash
# Check environment variables loaded
docker-compose config

# Verify .env file format (no spaces around =)
cat .env | grep "= "  # Should return nothing

# Check for CHANGE_ME values
grep CHANGE_ME .env
```

### Lost access to Authelia

```bash
# Reset Authelia database
cd Authelia/Authelia
docker-compose down
rm -rf authelia_data  # WARNING: Loses all 2FA registrations
docker-compose up -d

# Or reset specific user password
docker run authelia/authelia:latest authelia crypto hash generate argon2 --password 'new-password'
# Update users_database.yml with new hash
```

### Git still tracking secret files

```bash
# Remove from git cache
git rm --cached path/to/secret/file

# Verify .gitignore
git check-ignore -v path/to/secret/file
```

## 📞 Need Help?

1. Check individual service READMEs
2. Review `SECURITY.md`
3. Run `./scripts/validate-secrets.sh`
4. Open an issue with details (never include actual secrets!)

---

**Remember:** Take your time with migration. It's better to be slow and careful than fast and insecure!
