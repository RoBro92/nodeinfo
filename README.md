# 📟 nodeinfo

**nodeinfo** is a lightweight CLI tool for inspecting and documenting Proxmox virtual machines (VMs) and LXC containers.  
It outputs system details, update status, and network configuration, then writes a structured summary directly into the Notes field of the specified VM or container.

---

## ⚙️ Features

- 🔍 Inspect a Proxmox VM or LXC by VMID  
- 📝 Updates the Notes field with a formatted summary  
- 🌐 Captures IP, VLAN, SSH, and web UI ports  
- 📦 Installable `.deb` package for quick deployment  
- 🧱 Works across Proxmox clusters  
- 🚀 GitHub Actions auto-build `.deb` releases  

---

## 🚀 Installation

1. Download the latest `.deb` from the [Releases](https://github.com/RoBro92/nodeinfo/releases) page and install it on your Proxmox host:

```bash 
   wget https://github.com/RoBro92/nodeinfo/releases/latest/download/nodeinfo_v0.2.3.deb
   ```
   
2. Install the package:

```bash
sudo dpkg -i nodeinfo_v0.2.3.deb`
```

3. Once installed you can run:

```bash
nodeinfo --help`
```

🛡️ Trusted Source

- This package is built and signed by the official GitHub repo.
- All releases are published through GitHub Actions from source.
- No external shell scripts or hidden install logic — you control every step.

## 🔧 Optional: Configure VLAN Names

4. After install, you can configure friendly VLAN names, you will be prompted to do this after install and can edit this file easily:

```bash
nodeinfo --vlan`
```

This opens /etc/nodeinfo/vlan.conf where you can map VLAN tags to descriptions (e.g, 10=Hypervisors)

## ❌ Uninstall

To remove nodeinfo completely you can run:

```bash
nodeinfo --remove`
```

This will:

- Remove the binary and config files
- clean up /etc/nodeinfo
- Prompt before deletion

---

### 🔧 Options
| Flag / Command    | Description                                      |
|-------------------|--------------------------------------------------|
| `<vmid>`          | ID of the VM or LXC container to inspect         |
| `--version`       | Show installed version of `nodeinfo`             |
| `--vlan`          | Open the VLAN name mapping file in your editor   |
| `update`          | Check for latest version and download            |
| `--help`          | Show usage help                                  |
| `--remove`        | Fully remove nodeinfo                            |

---

### Examples

- `nodeinfo 100` → Inspect VM 100, create the markdown file and place into the summary notes on the VM
- `nodeinfo 202` → Inspect LXC 202  create the markdown file and place into the summary notes on the LXC


---
## 📘 Changelog

See full changelog [here](./CHANGELOG.md)
## 📁 Repo Structure

---

Key files and folders used for development and packaging:

- `.github/workflows/` – GitHub Actions for building and releasing `.deb` packages  
- `Makefile` – Automates versioning, building, and release  
- `nodeinfo/` – Debian packaging directory:
  - `DEBIAN/control` – Metadata (version is auto-pulled from `nodeinfo.py`)  
  - `DEBIAN/postinst` - Post install script that creates the necessary vlan.conf files and intiiates invite to update VLAN's
  - `usr/local/bin/nodeinfo` – Main installed CLI executable  
  - `usr/local/bin/share/nodeinfo/template.md` - This file is not in use currently but will be the location for the note template so it can be updated and versioned seperately. 

> 💡 Only `usr/local/bin/nodeinfo` is included in the installed package. All other files support development.

---

