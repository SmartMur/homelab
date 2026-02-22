## Summary

Describe what changed and why.

## Validation

List commands run and key outcomes:

```bash
./scripts/validate-secrets.sh
pre-commit run --all-files
```

## Checklist

- [ ] Scoped change with clear purpose
- [ ] Service docs updated if behavior changed
- [ ] No secrets/tokens/keys introduced
- [ ] Security checks passed
- [ ] `docs/SECURITY_RULEBOOK.md` reviewed for security-sensitive changes
- [ ] If incident-related: history rewrite and collaborator recovery steps documented

## Risk Notes

List potential regressions and mitigation plan.
