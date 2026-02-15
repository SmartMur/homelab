# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2024-01-15 - Security Overhaul

### 🔒 Security Improvements

#### Added
- **Environment Variable Management**
  - `.env.example` templates for all services
  - Centralized secret management structure
  - Secure secret generation scripts
  - Secret validation and rotation tools

- **Pre-commit Hooks**
  - Automatic detection of committed secrets
  - Prevention of `.env` file commits
  - Validation of YAML and Docker Compose files
  - Detection of hardcoded credentials

- **Ansible Vault Integration**
  - Encrypted secret storage for automation
  - Complete migration guide from plaintext
  - Example templates and documentation

- **Documentation**
  - `SECURITY.md` - Security best practices
  - `README.md` - Comprehensive overview
  - `QUICKSTART.md` - Fast deployment guide
  - `DEPLOYMENT.md` - Detailed deployment steps
  - `MIGRATION-GUIDE.md` - Migration from old structure
  - `CONTRIBUTING.md` - Contribution guidelines
  - Service-specific READMEs

- **Helper Scripts**
  - `scripts/generate-secrets.sh` - Generate secure random secrets
  - `scripts/validate-secrets.sh` - Validate configuration security
  - `scripts/rotate-secrets.sh` - Assist with secret rotation
  - `scripts/init-homelab.sh` - Initial setup wizard
  - `scripts/setup-secrets.sh` - Automated .env file creation

#### Changed
- **Authelia Configuration**
  - Externalized all secrets to environment variables
  - Created template configuration files
  - Added Redis with password authentication
  - Improved healthchecks and security options

- **Watchtower**
  - Migrated from Docker secrets to environment variables
  - Added HTTP API token support
  - Improved configuration flexibility
  - Added comprehensive README

- **Docker Compose Files**
  - Updated to version 3.8
  - Added `env_file` references
  - Implemented named volumes
  - Added security options (`no-new-privileges`)
  - Improved healthchecks

- **.gitignore**
  - Comprehensive exclusion patterns
  - Explicit secret file blocking
  - Allow `.example` files
  - Protect Ansible vault files

#### Removed
- ❌ Hardcoded secrets from all configuration files
- ❌ Plaintext password files
- ❌ Embedded API tokens
- ❌ Unencrypted credential files

### 📝 Template Files Created

New `.example` files for:
- Authelia (configuration.yml, users_database.yml, .env)
- Traefik/Traefikv3 (.env, cf-token)
- Watchtower (.env)
- Nginx (cloudflare.ini, .env)
- DynamicDNS (config, script.sh, .env)
- Tinyauth (users, .env)
- Ente (credentials.yaml)
- Popup-Homelab (.env)
- Ansible secrets (secrets.yml)

### 🔧 Infrastructure

- Added pre-commit configuration with multiple security checks
- Created secrets baseline for detect-secrets tool
- Implemented automated validation workflows
- Added contribution guidelines

### 📚 Documentation Improvements

- Complete security documentation
- Step-by-step deployment guides
- Service-specific setup instructions
- Troubleshooting sections
- Best practices and checklists

## Migration Notes

For users upgrading from previous versions:

1. **Backup everything** before proceeding
2. Read `MIGRATION-GUIDE.md` thoroughly
3. Extract existing secrets to secure location
4. Run `./scripts/init-homelab.sh`
5. Populate new `.env` files with your secrets
6. Test each service individually
7. Remove old secret files after verification
8. Rotate any previously exposed secrets

## Breaking Changes

⚠️ **This is a major version change with breaking changes:**

- Configuration file locations changed
- Environment variables now required for all services
- Docker Compose files restructured
- Volume paths may need updating
- Secrets must be migrated to new structure

**Do not upgrade production without testing first!**

## Security Advisories

If you were using the previous version with hardcoded secrets:

1. **Rotate ALL secrets** immediately
2. Assume previously committed secrets are compromised
3. Review git history for exposed credentials
4. Consider cleaning git history (see MIGRATION-GUIDE.md)
5. Update credentials at source (Cloudflare, etc.)

## [1.0.0] - Previous Version

Legacy version with hardcoded configuration.
**Not recommended for production use due to security concerns.**

---

## Version Numbering

This project follows [Semantic Versioning](https://semver.org/):
- MAJOR version for incompatible API/structure changes
- MINOR version for backwards-compatible functionality additions
- PATCH version for backwards-compatible bug fixes
