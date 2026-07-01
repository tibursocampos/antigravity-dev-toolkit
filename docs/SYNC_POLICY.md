# Cross-toolkit sync policy

How **antigravity-dev-toolkit** and **cursor-dev-toolkit** stay aligned.

See the same policy in [cursor-dev-toolkit/docs/SYNC_POLICY.md](https://github.com/raphadev/cursor-dev-toolkit/blob/master/docs/SYNC_POLICY.md) (or local sibling repo).

## Summary

- **Antigravity → Cursor:** stack skills, domain guidelines, orchestrating `developer` pattern.
- **Cursor → Antigravity:** `developer_common`, `format_validators`, `add_migrations`, `create_message_consumer`, line-limit validation, maintainer docs.
- **`dev_persona`:** remains Antigravity-only unless Antigravity adopts split rules like Cursor.

## Validation

```powershell
.\scripts\sync-antigravity.ps1
.\scripts\validation\validate-all.ps1
```
