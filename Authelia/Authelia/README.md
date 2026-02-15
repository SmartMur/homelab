# Authelia Setup

Authelia is an open-source authentication and authorization server providing two-factor authentication and single sign-on (SSO).

## Quick Start

### 1. Setup Configuration Files

```bash
# Copy example files
cp .env.example .env
cp configuration.yml.example configuration.yml
cp users_database.yml.example users_database.yml
```

### 2. Generate Secrets

```bash
# Use the helper script
../../../scripts/generate-secrets.sh

# Or manually generate:
openssl rand -base64 64  # For JWT, Session, and Encryption secrets
openssl rand -base64 32  # For Redis password
```

### 3. Update .env File

Edit `.env` and replace all `CHANGE_ME` values with the generated secrets.

### 4. Configure Users

Edit `users_database.yml` and add your users. Generate password hashes:

```bash
docker run authelia/authelia:latest authelia crypto hash generate argon2 --password 'your-password'
```

### 5. Update Domain

Edit `.env` and set your domain:
```
AUTHELIA_DOMAIN=smartmur.lab
AUTHELIA_DEFAULT_REDIRECTION_URL=https://smartmur.lab/
```

### 6. Start Services

```bash
docker-compose up -d
```

## Configuration

### Environment Variables

All sensitive configuration is managed via environment variables in `.env`:
- `AUTHELIA_JWT_SECRET` - JWT token signing secret
- `AUTHELIA_SESSION_SECRET` - Session encryption secret
- `AUTHELIA_STORAGE_ENCRYPTION_KEY` - Database encryption key
- `REDIS_PASSWORD` - Redis authentication password

### User Management

Users are defined in `users_database.yml`. For production, consider using LDAP/AD instead.

### Email Notifications (Optional)

Uncomment and configure SMTP settings in `.env` to enable email notifications for password resets and 2FA registration.

## Security Best Practices

1. ✅ **Never commit `.env`, `configuration.yml`, or `users_database.yml`** to git
2. ✅ **Use strong, randomly generated secrets** (minimum 32 characters)
3. ✅ **Rotate secrets regularly** (every 90 days recommended)
4. ✅ **Use HTTPS only** - Configure Traefik or reverse proxy with valid SSL certificates
5. ✅ **Enable 2FA** for all users
6. ✅ **Regular backups** of the database and configuration

## Integration with Traefik

The docker-compose.yaml includes Traefik labels for automatic HTTPS routing. Ensure:
- Traefik network `proxy` exists
- Domain DNS points to your server
- Traefik is configured for HTTPS/SSL

## Troubleshooting

### Check logs
```bash
docker-compose logs -f authelia
```

### Verify configuration
```bash
docker-compose exec authelia authelia validate-config /config/configuration.yml
```

### Reset user password
```bash
# Generate new hash
docker run authelia/authelia:latest authelia crypto hash generate argon2 --password 'new-password'

# Update users_database.yml with new hash
# Restart: docker-compose restart authelia
```

## Additional Resources

- [Official Documentation](https://www.authelia.com/docs/)
- [Configuration Reference](https://www.authelia.com/configuration/)
- [Integration Guides](https://www.authelia.com/integration/)
