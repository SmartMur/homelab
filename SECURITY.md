# Security Best Practices

## Overview
This repository has been designed with security-first principles. All sensitive credentials are externalized and never committed to version control.

## Secret Management Strategy

### 1. Environment Variables (.env files)
- Each service uses a `.env` file for secrets (gitignored)
- `.env.example` templates are provided for each service
- Never commit actual `.env` files

### 2. Ansible Vault
- All Ansible secrets use `ansible-vault` encryption
- Vault password stored separately (never in repo)
- Example: `ansible-vault create secrets.yml`

### 3. Secret Generation
- Use provided `scripts/generate-secrets.sh` for creating secure random secrets
- Minimum secret length: 32 characters for tokens/keys
- Use bcrypt/argon2 for password hashing

## Setup Instructions

### Initial Setup
```bash
# 1. Copy all .env.example files to .env
find . -name ".env.example" -exec sh -c 'cp "$1" "${1%.example}"' _ {} \;

# 2. Generate secure secrets
./scripts/generate-secrets.sh

# 3. Update .env files with your actual values
# 4. Never commit .env files
```

### Pre-commit Hooks
```bash
# Install pre-commit hooks to prevent secret leaks
pre-commit install
```

## What NOT to Commit
- `.env` files
- `*password*`, `*secret*`, `*token*` files (unless examples)
- API keys, certificates, private keys
- User databases with real credentials
- Configuration files with embedded secrets

## Secret Rotation
- Rotate secrets every 90 days minimum
- Use `scripts/rotate-secrets.sh` helper
- Update all dependent services

## Reporting Security Issues
Please report security vulnerabilities to [your-email]
