# Security Policy

## Supported Versions

Security fixes target the latest state of `main`.

## Rulebook

The authoritative operating rules and incident playbook live in:

- `docs/SECURITY_RULEBOOK.md`

All contributors are expected to follow that document for day-to-day security workflow and incident handling.

## Reporting Security Issues

Do not open public issues for sensitive vulnerabilities.

Use one of:

- GitHub Security Advisory (preferred)
- Maintainer private contact channel

Include:

- Vulnerability description
- Reproduction steps
- Impact assessment
- Suggested remediation (if available)

## Secret Leakage Procedure (Mandatory)

If a secret is exposed:

1. Revoke or rotate immediately.
2. Remove leaked content from the current branch.
3. If history is affected, rewrite history and force-push rewritten refs.
4. Notify collaborators to re-clone or hard reset.
5. Re-run checks:
   - `./scripts/validate-secrets.sh`
   - `pre-commit run --all-files`

Use `docs/SECURITY_RULEBOOK.md` for exact command-level incident steps.

## Security Tooling

Baseline checks:

- `scripts/validate-secrets.sh`
- pre-commit hooks from `.pre-commit-config.yaml`
- CI workflow: `.github/workflows/security-scan.yml`

## Secret Management Baseline

- Keep secrets in local `.env` files only (gitignored).
- Track only `*.example` templates.
- Use `scripts/generate-secrets.sh` and `scripts/rotate-secrets.sh` for lifecycle management.
- Use Ansible Vault for encrypted automation secrets.
