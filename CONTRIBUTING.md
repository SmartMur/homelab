# Contributing Guidelines

Thank you for considering contributing to this homelab infrastructure repository!

## 🔒 Security First

**NEVER commit secrets, passwords, tokens, or any sensitive information.**

Before contributing, ensure:
- Pre-commit hooks are installed: `pre-commit install`
- All sensitive data uses `.env` files or Ansible Vault
- Example files use `CHANGE_ME` placeholders

## 📋 Contribution Checklist

- [ ] Pre-commit hooks installed and passing
- [ ] No hardcoded secrets in code
- [ ] `.env.example` file provided for new services
- [ ] README.md created/updated for the service
- [ ] Docker Compose file uses environment variables
- [ ] Security best practices followed
- [ ] Tested in development environment
- [ ] Documentation updated

## 🎯 What to Contribute

### New Services
- Add new self-hosted applications
- Include complete configuration
- Provide `.env.example` template
- Add service-specific README
- Include Traefik labels for reverse proxy

### Improvements
- Security enhancements
- Documentation improvements
- Bug fixes
- Performance optimizations
- Better secret management

### Scripts
- Automation scripts
- Helper utilities
- Validation tools
- Backup solutions

## 📝 Pull Request Process

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/new-service
   ```

3. **Make your changes**
   - Follow existing patterns
   - Use environment variables
   - Include `.example` files

4. **Test your changes**
   ```bash
   # Validate configuration
   ./scripts/validate-secrets.sh
   
   # Test docker-compose
   docker-compose config
   docker-compose up -d
   ```

5. **Run pre-commit checks**
   ```bash
   pre-commit run --all-files
   ```

6. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add: [Service Name] configuration"
   ```

7. **Push to your fork**
   ```bash
   git push origin feature/new-service
   ```

8. **Create Pull Request**
   - Describe what you added/changed
   - Include testing steps
   - Reference any related issues

## 🎨 Code Style

### Docker Compose Files
```yaml
version: '3.8'

services:
  service-name:
    image: service:latest
    container_name: service-name
    env_file:
      - .env
    environment:
      - TZ=${TZ:-UTC}
      - SERVICE_SECRET=${SERVICE_SECRET}
    volumes:
      - service_data:/data
    networks:
      - proxy
    security_opt:
      - no-new-privileges:true
    restart: unless-stopped

volumes:
  service_data:

networks:
  proxy:
    external: true
```

### Environment Files
```bash
# Service Name Environment Variables
# Copy this file to .env and fill in your actual values

# Generate secrets with: ../../scripts/generate-secrets.sh

# Primary secret
SERVICE_SECRET=CHANGE_ME_GENERATE_WITH_openssl_rand

# Configuration
DOMAIN=smartmur.lab
TZ=UTC
```

### README Files

Each service should have:
```markdown
# Service Name

Brief description

## Quick Start

### 1. Setup
```bash
cp .env.example .env
vim .env  # Update secrets
```

### 2. Deploy
```bash
docker-compose up -d
```

## Configuration

Environment variables explained...

## Security

Security considerations...

## Troubleshooting

Common issues and solutions...
```

## 🧪 Testing

Before submitting:

```bash
# Validate secrets
./scripts/validate-secrets.sh

# Test compose file
cd YourService
docker-compose config

# Start service
docker-compose up -d

# Check logs
docker-compose logs -f

# Test functionality
# (Access web UI, test features, etc.)

# Clean up
docker-compose down -v
```

## 📚 Documentation

Good documentation includes:
- Clear setup instructions
- Environment variable descriptions
- Security considerations
- Troubleshooting section
- Links to official documentation

## ❌ What NOT to Do

- ❌ Commit `.env` files
- ❌ Commit passwords or tokens
- ❌ Commit API keys
- ❌ Use hardcoded secrets
- ❌ Commit without testing
- ❌ Skip pre-commit hooks
- ❌ Use absolute paths (use relative or env vars)
- ❌ Commit large binary files

## ✅ Best Practices

- ✅ Use environment variables for configuration
- ✅ Provide `.example` files for sensitive configs
- ✅ Include health checks in compose files
- ✅ Use named volumes
- ✅ Set proper file permissions
- ✅ Include security_opt: no-new-privileges
- ✅ Use specific image tags (not `latest` in production)
- ✅ Document all requirements

## 🐛 Bug Reports

When reporting bugs:

1. **Check existing issues first**
2. **Provide details:**
   - Service name and version
   - Docker version: `docker --version`
   - Compose version: `docker-compose --version`
   - OS/Distribution
   - Error messages (sanitize any secrets!)
   - Steps to reproduce

3. **Never include:**
   - Actual passwords
   - Real API tokens
   - Private keys
   - Personal information

## 💡 Feature Requests

For new features:
- Describe the feature
- Explain the use case
- Suggest implementation (if possible)
- Consider security implications

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## 🤝 Code of Conduct

- Be respectful and inclusive
- Help others learn
- Accept constructive criticism
- Focus on what's best for the community

## ❓ Questions?

- Open a discussion
- Check existing documentation
- Review other examples in the repo

---

Thank you for contributing! 🎉
