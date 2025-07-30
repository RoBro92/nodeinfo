All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)  
and this project adheres to [Semantic Versioning](https://semver.org/).

---
## [1.1.0] - 2025-07-30
### 🚀 Added

#### Major Features
- **🔐 SSH Support for VMs**  
  - Securely connect to most Linux-based VMs using SSH key-based authentication.  
  - Keys are generated silently (unless in debug mode) and auto-pushed with user approval.  
  - SSH-based data collection improves accuracy for VMs lacking QEMU Guest Agent.  
  - Optional removal of SSH key and config after use for added security and transparency.

- **🖥️ Improved VM Support**  
  - Substantially better information gathering for QEMU VMs via SSH.  
  - Automatic fallback to container name if hostname is reported as `localhost`.

#### Enhancements
- **🧠 Smart SSH Detection**: Prompts to install SSH server if unavailable inside the VM.  
- **📁 `ssh.conf` Auto-Management**: Automatically populated during nodeinfo runs.  
- **🔄 Retry & Fallback Logic**: More robust SSH handling and logging.  
- **🔍 Debug Prints**: Expanded logging for SSH operations and troubleshooting.

---

### 🛠️ Fixes

- ✅ Improved cleanup of SSH keys and config entries after note updates.  
- 🐞 Minor bugfixes in update-checker and VLAN config handling.

## [1.0.1] - 2025-07-30
### 🚀 Added
- 💾 Automatic backup of VM config files
- 🧾 `-y/ --yes` to skip notes prompt (still prompts for VMs)

### 🛠️ Fixes
- 🧷 VM support via direct `.conf` editing

---


## [1.0.0] - 2025-07-30
### 🚀 Added
- 🌐 Public release

---

## [0.3.5] - 2025-07-30
### 🚀 Added
- 🐞 Supports `--debug` to enable debug mode and print outputs for each command, run again to disable
- 🌐 Gateway and DNS resolver status

### 🧹 Removed
- 🗒️ User Notes due to persistence issues

---

## [0.2.8] - 2025-07-30
### 🚀 Added
- 📝 Updated summary note template to include information about VM/LXC OS update availability

### 🛠️ Fixes
- 🧷 Fixed notes and issues not being preserved when running again

---

## [0.2.7] - 2025-07-30
### 🚀 Added
- 🔍 Refined SSH scraping
- ⚠️ Prompt when running if the notes file already contains data
- 🛡️ Check if notes was previously populated by nodeinfo so it will not replace user notes

---

## [0.2.5] - 2025-07-30
### 🚀 Added
- ⬆️ Updated `update` to check for new version and confirm if user wishes to download:
    1. 🔎 Checks for latest version from GitHub Releases.
    2. 📊 Compares with the current version (VERSION constant).
    3. ✅ Asks the user for confirmation before proceeding.
    4. 📥 Downloads the .deb file into `/tmp`.
    5. 💾 Backs up `/etc/nodeinfo/vlan.conf` only if it exists and is non-empty.
    6. 🛠️ Installs the new .deb using `dpkg -i`.
    7. ♻️ Restores the backup of `vlan.conf` if it was backed up.
    8. 📝 Handles errors gracefully and provides clear output.

---

## [0.2.3] - 2025-07-30
### 🚀 Added
- 🗑️ Supports `--remove` to fully remove package and components

---

## [0.2.2] - 2025-07-30
### 🛠️ Fixes
- 🧷 Template for VLANs

---

## [0.2.1] - 2025-07-30
### 🚀 Added
- 🗒️ Changelog
- 📄 `template.md` file added for future segregation of notes template
- 🏷️ Option to configure VLAN names on install using `--vlan`

---

## [0.1.6] - 2025-07-30
### 🚀 Added
- 🔎 Version check and GitHub update feature (`nodeinfo update`)
- 📖 Auto-updates README with correct .deb version
- 📝 Release notes support in `make release NOTES="..."`

---

## [0.1.4] - 2025-07-30
### 🛠️ Fixes
- 🧷 Corrected `--version` handling
- 🧹 Cleaned up README formatting and usage examples

---

## [0.1.3] - 2025-07-30
### 🚀 Added
- 🏷️ VLAN/subnet name resolution
- ✍️ Markdown formatting improvements for Proxmox Notes

---

## [0.1.0] - 2025-07-29
### 🎉 Initial Release
- 🖥️ Basic VM/LXC inspection
- 📝 Auto-write system info to Notes field
- 🆘 Supports `--help`, `--version`, `nodeinfo <vmid>`

---
