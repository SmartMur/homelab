# Ansible Secrets Management

This directory contains sensitive variables for Ansible playbooks using `ansible-vault` for encryption.

## ⚠️ SECURITY WARNING

**NEVER commit unencrypted secrets to git!** All sensitive data must be encrypted with `ansible-vault`.

## Setup

### 1. Create Vault Password File
```bash
# Create a secure password for the vault
openssl rand -base64 32 > ~/.ansible_vault_pass

# Secure the file
chmod 600 ~/.ansible_vault_pass
```

### 2. Configure Ansible to Use Vault Password
Add to `ansible.cfg`:
```ini
[defaults]
vault_password_file = ~/.ansible_vault_pass
```

## Usage

### Create Encrypted Secrets File
```bash
ansible-vault create secrets.yml
```

Example content:
```yaml
---
# Database credentials
db_password: "your_secure_password"
db_root_password: "your_root_password"

# API keys
cloudflare_api_token: "your_api_token"

# SSH keys
ssh_private_key: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  ...
  -----END OPENSSH PRIVATE KEY-----
```

### Edit Encrypted File
```bash
ansible-vault edit secrets.yml
```

### View Encrypted File
```bash
ansible-vault view secrets.yml
```

### Encrypt Existing File
```bash
ansible-vault encrypt plaintext_secrets.yml
```

### Decrypt File (Use with Caution!)
```bash
ansible-vault decrypt secrets.yml
# Remember to re-encrypt: ansible-vault encrypt secrets.yml
```

### Change Vault Password
```bash
ansible-vault rekey secrets.yml
```

## Using Secrets in Playbooks

### Include Encrypted Variables
```yaml
---
- hosts: all
  vars_files:
    - secrets.yml
  tasks:
    - name: Use secret variable
      debug:
        msg: "{{ db_password }}"
```

### Run Playbook
```bash
# With vault password file configured:
ansible-playbook playbook.yml

# Or specify password file explicitly:
ansible-playbook playbook.yml --vault-password-file ~/.ansible_vault_pass

# Or prompt for password:
ansible-playbook playbook.yml --ask-vault-pass
```

## Best Practices

1. ✅ **Encrypt ALL sensitive data** - passwords, tokens, keys, certificates
2. ✅ **Store vault password securely** - never commit to git
3. ✅ **Use separate vaults** for different environments (dev/staging/prod)
4. ✅ **Rotate secrets regularly** - update and rekey vault files
5. ✅ **Document required secrets** - maintain a template file
6. ✅ **Use group_vars and host_vars** - organize secrets by scope

## File Organization

```
Ansible/Playbooks/
├── Secrets-Variables/
│   ├── README.md (this file)
│   ├── secrets.yml.example (template - safe to commit)
│   ├── secrets.yml (encrypted - gitignored)
│   └── production_secrets.yml (encrypted - gitignored)
└── playbook.yml
```

## Creating Secret Templates

**secrets.yml.example** (safe to commit):
```yaml
---
# Database credentials
db_password: "CHANGE_ME"
db_root_password: "CHANGE_ME"

# API keys
cloudflare_api_token: "CHANGE_ME"
```

Users copy and encrypt:
```bash
cp secrets.yml.example secrets.yml
ansible-vault encrypt secrets.yml
ansible-vault edit secrets.yml  # Add real values
```

## Troubleshooting

### Error: "Decryption failed"
- Check vault password is correct
- Verify vault password file path in ansible.cfg

### Error: "Vault format unhelpful_error"
- File may be corrupted
- Restore from backup and re-encrypt

### Forgot Vault Password
- If no backup: secrets are unrecoverable
- Always keep vault password backed up securely

## Additional Resources

- [Ansible Vault Documentation](https://docs.ansible.com/ansible/latest/user_guide/vault.html)
- [Best Practices for Variables](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#variables-and-vaults)
