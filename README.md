# 📟 nodeinfo

**nodeinfo** is a lightweight CLI tool for inspecting and documenting Proxmox virtual machines (VMs) and LXC containers.  
It outputs system details, update status, and network configuration, then writes a structured summary directly into the Notes field of the specified VM or container.

---

## ⚙️ Features

- 🔍 Inspect a Proxmox VM or LXC by VMID  
- 📝 Updates the Notes field with a formatted summary  
- 🌐 Captures IP, VLAN, SSH, and web UI ports  
- 📦 Installable `.deb` package for quick deployment  
- 🧱 Built for Proxmox
- 🚀 GitHub Actions auto-build `.deb` releases 
---

### Example Output

Below is a example output after running the command, this information is placed into the notes within the summary page and gives you a quick view of the container details. 

 🖥️ **Container/VM Information**
 
 - **Hostname**: homepage
 - **Type**: lxc
 - **Operating System**: Debian GNU/Linux 12 (bookworm)
 - **IP Address**: 192.168.70.13
 - **Gateway**: 192.168.70.1
 - **Gateway Reachable**: ✅ Reachable
 - **DNS Servers**: 192.168.70.11
 - **DNS Resolving**: ✅ Resolving
 - **VLAN/Subnet**: 70 – Infrastructure
 
 🔒 **Access & Credentials**
 
 - **Web UI URL**: http://192.168.70.13
 - **SSH Access**: 🟢 Enabled
 - **SSH Port**: 22
 - **Auth Method**: Assumed Password
 - **Allow Root Login**: Yes
 
 🔄 **Update Status**
 
 - **Last apt update**: Unavailable
 - **Package status**: Up to date


---
## 💡 Feature Requests & Support

Have an idea or need help? Feel free to open an issue or start a discussion on [GitHub Issues](https://github.com/RoBro92/nodeinfo/issues). I'm actively improving `nodeinfo` and welcome your suggestions!

---
## 📘 Changelog

See full changelog [here](./CHANGELOG.md)
---
## 🚀 Installation

1. Download the latest `.deb` from the [Releases](https://github.com/RoBro92/nodeinfo/releases) page and install it on your Proxmox host:

```bash 
wget https://github.com/RoBro92/nodeinfo/releases/latest/download/nodeinfo_v1.0.5.deb
```
   
2. Install the package:

```bash
dpkg -i nodeinfo_v1.0.5.deb
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
nodeinfo --vlan
```

This opens /etc/nodeinfo/vlan.conf where you can map VLAN tags to descriptions (e.g, 10=Hypervisors)

## ❌ Uninstall

To remove nodeinfo completely you can run:

```bash
nodeinfo --remove
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
| `-y/--yes`        | Install new notes and skip overwrite check       |
| `--ssh`           | Open SSH config file for connecting to VMs       |

### Examples

- `nodeinfo 100` → Inspect VM 100, create the markdown file and place into the summary notes on the VM
- `nodeinfo 202` → Inspect LXC 202  create the markdown file and place into the summary notes on the LXC
- `nodeinfo 303` - Inspect VM/LXC 303 and skip prompt for override. (Will still promt if a VM for backup)

---
### 🔐 SSH Integration

If a VM lacks QEMU Guest Agent support, `nodeinfo` can use SSH to extract system data.

To configure:

1. Add the VM's IP and optional port in `/etc/nodeinfo/ssh.conf`: 105=192.168.10.45:22
```bash
nodeinfo --ssh
```
2. Deploy the SSH key: Make sure the VM allows SSH key login and root access (or change the user accordingly).
```bash
ssh-copy-id -i /etc/nodeinfo/id_nodeinfo.pub root@<VMIP>
```

---


## 🛣️ Roadmap

📅 See the full [ROADMAP.md](./ROADMAP.md) for upcoming plans.

### 🔄 In Progress / Planned
- 🔧 Add argument when generating for what is included in the container to correctly update port for web ui.
- 🔧 Scheduled Runs via Cron
- 🔧 Cluster support to enable running and install on a single node
- 📌 Persist `User Notes` section across runs
- 📌 APT Package Repository
- 📌 Service aware checks for docker/nginx/plex etc and report status of these services in the notes
- 📌 Auto Update
- 📌 Config files for defaults and behaviour 

### ✅ Completed
- Add debug mode (`--debug`)
- SSH status detection (enabled, disabled, not installed)
- DNS and gateway health checks
- Preserves config lines and confirms overwrite
- `--update` command for checking latest version
- `.deb` installer with postinstall prompts

---
  
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

