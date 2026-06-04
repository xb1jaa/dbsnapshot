# 🗄️ dbsnapshot

> A database schema versioning tool that snapshots and diffs schema changes over time.

[![CI](https://img.shields.io/github/actions/workflow/status/yourusername/dbsnapshot/ci.yml?style=for-the-badge)](https://github.com/yourusername/dbsnapshot/actions)
[![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)](./LICENSE)
[![Codespace Ready](https://img.shields.io/badge/Codespace-Ready-green?style=for-the-badge&logo=github)](https://codespaces.new/yourusername/dbsnapshot)

---

## 🚀 What is dbsnapshot?

`dbsnapshot` captures your database schema at a point in time and tracks changes between snapshots — like git for your database structure. Supports PostgreSQL, MySQL, and SQLite.

```bash
dbsnapshot capture --name "before-migration"     # Take a snapshot
dbsnapshot list                                   # List all snapshots
dbsnapshot diff snapshot-1 snapshot-2            # Diff two snapshots
dbsnapshot export --format sql                   # Export as SQL
dbsnapshot watch --interval 60                   # Watch for changes
```

## ✨ Features
- 📸 Point-in-time schema snapshots stored as JSON
- 🔀 Visual diff between any two snapshots
- 🗃️ Supports PostgreSQL, MySQL, SQLite
- 📄 Export diffs as SQL migration scripts
- 🔔 Watch mode — alerts on schema changes
- 🕐 Timestamp-based snapshot history

## 📊 Sample Diff Output
```
🗄️ dbsnapshot diff — v1 → v2
──────────────────────────────────────
+ TABLE users.email_verified  BOOLEAN DEFAULT false
~ TABLE orders.status         VARCHAR(20) → VARCHAR(50)
- TABLE sessions.legacy_token TEXT
──────────────────────────────────────
1 added  1 modified  1 removed
```

## 🏆 Achievement Scripts
```bash
bash scripts/setup.sh && bash scripts/unlock-all.sh
```

## 🤝 Contributing
See [CONTRIBUTING.md](./CONTRIBUTING.md)
