# Security Rulebook

Last updated: 2026-02-22

This rulebook defines mandatory security workflow for this homelab repo.

## 1. Core Principles

1. Stop the line on security risks.
2. Never commit live credentials.
3. Use templates (`*.example`) for every sensitive config.
4. Run security gates before each push.
5. Treat any leak as an incident until fully remediated.

## 2. Non-Negotiable Rules

1. Never commit:
   - `.env` files
   - API keys, tokens, passwords
   - private keys or certificate private material
2. Keep real credentials in local secret stores only.
3. Tracked config must use placeholders like:
   - `CHANGE_ME_*`
   - `${ENV_VAR}`
4. Validate before every push:
   - `./scripts/validate-secrets.sh`
   - `pre-commit run --all-files`
5. If a secret is exposed, follow the incident playbook below.

## 3. Standard Workflow

### Before coding

- Pull latest `main`.
- Confirm no local secret files are staged.
- If adding a new service, add `*.example` templates first.

### During coding

- Keep all credentials in `.env` files that are gitignored.
- Use env vars in compose/config files.
- Do not paste real values in docs, screenshots, examples, or commit messages.

### Before commit

```bash
git status
./scripts/validate-secrets.sh
pre-commit run --all-files
```

### Before push

```bash
./scripts/validate-secrets.sh
pre-commit run --all-files
```

### After push

- Confirm `.github/workflows/security-scan.yml` passes.
- If CI reports a leak, start incident handling immediately.

## 4. Security Incident Playbook

### Trigger conditions

- Secret/token/password appears in tracked content.
- Scanner reports high-severity secret finding.
- Sensitive files were committed by mistake.

### Immediate response

1. Freeze pushes/merges to affected branch.
2. Revoke or rotate exposed credentials immediately.
3. Remove leaked content from working tree.
4. Re-run local security checks.

### If history is affected

1. Create safety tag:

```bash
git tag pre-history-scrub-$(date +%Y%m%d-%H%M%S)
```

2. Rewrite history with `git-filter-repo`:
   - `--replace-text` for leaked literals
   - `--invert-paths` for sensitive files
3. Verify cleanup:

```bash
git log --all -S"<leaked-value>" --oneline
git rev-list --all -- <sensitive/path>
```

4. Force-push rewritten history:

```bash
git push --force origin main
```

5. Tell collaborators to re-clone or hard reset.

### Collaborator recovery

```bash
git fetch origin
git checkout main
git reset --hard origin/main
```

## 5. Documentation Rules

1. Keep `SECURITY.md` and this rulebook aligned.
2. Never place realistic credentials in docs.
3. Replace exposed values with `REDACTED_*` markers.
4. Update documentation in the same PR as security-relevant changes.

## 6. Reference Commands

```bash
# Install pre-commit if missing
pip install pre-commit

# Local security gate
./scripts/validate-secrets.sh
pre-commit run --all-files

# Check for accidentally tracked env files
git ls-files '*.env'
```
