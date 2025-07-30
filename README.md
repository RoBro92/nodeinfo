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

## 🚀 Installation & Update

Download the latest `.deb` from the [Releases](https://github.com/RoBro92/nodeinfo/releases) page and install it on your Proxmox host:

1. `wget https://github.com/RoBro92/nodeinfo/releases/latest/download/nodeinfo_v0.1.4.deb`
2. `sudo dpkg -i nodeinfo_v0.1.4.deb`

To update once installed run: - `nodeinfo update`


---

## 🧑‍💻 Usage

Run the command from a Proxmox host shell as root:

`nodeinfo <vmid>`

### Examples

- `nodeinfo 100` → Inspect VM 100  
- `nodeinfo 202` → Inspect LXC 202  

---

## 🧹 Additional Commands

- `nodeinfo --help` – Display help message  
- `nodeinfo --version` – Show current version  
- `nodeinfo update` – Check for updates  

---

## 📁 Repo Structure

Key files and folders used for development and packaging:

- `.github/workflows/` – GitHub Actions for building and releasing `.deb` packages  
- `Makefile` – Automates versioning, building, and release  
- `nodeinfo/` – Debian packaging directory:
  - `debian/control` – Metadata (version is auto-pulled from `nodeinfo.py`)  
  - `usr/local/bin/nodeinfo` – Main installed CLI executable  

> 💡 Only `usr/local/bin/nodeinfo` is included in the installed package. All other files support development.

---

