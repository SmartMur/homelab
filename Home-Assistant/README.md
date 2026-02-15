# Home Assistant Setup

Home Assistant is an open-source home automation platform.

## Quick Start

### 1. Setup Secrets
```bash
cd Home-Assistant
cp secrets.yaml.example secrets.yaml
vim secrets.yaml  # Update with your actual values
```

### 2. Configure Environment
```bash
cp .env.example .env
vim .env  # Set timezone and other settings
```

### 3. Deploy
```bash
docker-compose up -d
```

## Configuration

### Secrets Management

Home Assistant uses `secrets.yaml` for sensitive data. Update these values:

- **SMTP Configuration** (for notifications):
  - `smtp_sender`: Your email address
  - `smtp_username`: Your email address
  - `smtp_password`: Gmail App Password (not your regular password!)
  - `smtp_recipient`: Where to send notifications

- **Database URL**:
  - Format: `postgresql://username:password@host/database`
  - Generate a strong password for the database user

### Gmail App Password

To use Gmail SMTP:
1. Enable 2FA on your Google account
2. Go to: https://myaccount.google.com/apppasswords
3. Create an app password for "Mail"
4. Use this password in `secrets.yaml`

## Security Notes

- ✅ Never commit `secrets.yaml` to git (it's gitignored)
- ✅ Use Home Assistant's `!secret` syntax for sensitive data
- ✅ Configure trusted proxies for reverse proxy setups
- ✅ Enable IP ban protection (already configured)
- ✅ Use strong database passwords

## Accessing Home Assistant

- **Local**: http://192.168.200.50:8123
- **Via Traefik**: https://home-assistant.smartmur.lab

## Troubleshooting

### Check logs
```bash
docker-compose logs -f homeassistant
```

### Validate configuration
```bash
# From Home Assistant UI: Configuration -> Server Controls -> Check Configuration
```

### SMTP not working
- Verify Gmail App Password is correct
- Check firewall allows outbound port 587
- Review Home Assistant logs for SMTP errors

## Additional Resources

- [Official Documentation](https://www.home-assistant.io/docs/)
- [SMTP Notifications](https://www.home-assistant.io/integrations/smtp/)
- [Secrets Management](https://www.home-assistant.io/docs/configuration/secrets/)
