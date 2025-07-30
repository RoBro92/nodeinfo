

# 🛣️ NodeInfo Roadmap

A document to track the progress, updates, and future plans for the `nodeinfo` tool.

---

## ✅ Completed Features

| Date       | Feature Description                                 |
|------------|-----------------------------------------------------|
| 2025-07-28 | Initial version with LXC/VM metadata injection      |
| 2025-07-29 | VLAN tagging support with `vlan.conf`               |
| 2025-07-29 | Added `--vlan` editing and default fallback message |
| 2025-07-30 | `--remove` command for full uninstall               |
| 2025-07-30 | `--update` command with GitHub version check        |
| 2025-07-30 | Vlan config preservation on update (`vlan.conf`)    |
| 2025-07-30 | Added SSH access detection and metadata reporting   |
| 2025-07-30 | Gateway and DNS status check per container/VM       |
| 2025-07-30 | Debug mode with `--debug` toggle                    |

---

## 📌 Planned Features

- 🧠 Intelligent update checker for Debian base + kernel version
- 📡 Integration with `pvecm` to gather cluster-wide info
- 🗃️ Persistent override notes section for custom user content
- 🛠️ Migration to native APT packaging and signing
- 📝 Optional Proxmox GUI integration to trigger `nodeinfo`