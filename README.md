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
- 🔐 SSH integration for improved data collection from VMs
- 🚀 GitHub Actions auto-build `.deb` releases 

---

## 🖥️ Example Output

Below is an example output placed into the VM or LXC Notes field:

```
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
```

---

## 🚀 Installation

1. Download the latest `.deb` from the [Releases](https://github.com/RoBro92/nodeinfo/releases) page:

```bash 
wget https://github.com/RoBro92/nodeinfo/releases/latest/download/nodeinfo_v1.1.0.deb
```

2. Install the package:

```bash
dpkg -i nodeinfo_v1.1.0.deb
```

3. Run the CLI tool:

```bash
nodeinfo --help
```

✅ **Trusted Source**  
- This package is built and signed by the official GitHub repo.
- All releases are published through GitHub Actions from source.
- No external shell scripts or hidden install logic — you control every step.

---

## 🔧 Optional: Configure VLAN Names

After install, you can configure friendly VLAN names:

```bash
nodeinfo --vlan
```

This opens `/etc/nodeinfo/vlan.conf` where you can map VLAN tags to descriptions (e.g., `10=Hypervisors`).

---

## ❌ Uninstall

To remove `nodeinfo` completely:

```bash
nodeinfo --remove
```

This will:

- Remove the binary and config files
- Clean up `/etc/nodeinfo`
- Prompt before deletion

---

## 🔐 SSH Integration (VMs)

If a VM lacks QEMU Guest Agent support, `nodeinfo` can use SSH to retrieve system info:

- The tool will prompt to set up SSH access automatically if needed.
- If approved, it will:
  1. Add the VM's IP to `ssh.conf`
  2. Send the SSH key to the VM
  3. Retest and update the Notes field using richer data via SSH

You will be asked for the VM's root password during this one-time setup. SSH access is revoked after the run if you confirm the prompt.

To manually review or configure:

```bash
nodeinfo --ssh
```

---

## 🛣️ Roadmap

📅 See full [ROADMAP.md](./ROADMAP.md) for upcoming plans.

### 🔄 In Progress / Planned
- 🔧 Scheduled runs via cron
- 🔧 Cluster-wide single-node deployment
- 🔧 Improved error reporting
- 🔧 dry run support 
- 🔧 Success summary
- 📌 Persist `User Notes` section across runs
- 📌 APT Package Repository
- 📌 Auto-update support
- 📌 Service-aware reporting (docker/nginx/plex etc.)
- 📌 Template-based note rendering

### ✅ Completed
- SSH Implementation for VM's
- -y flag for skipping overwrite checks
- Debug mode (`--debug`)
- SSH status detection & key injection
- DNS and gateway health checks
- Safe overwrite confirmation
- `--update` version checker
- `.deb` installer with post-install prompts

---

## 📘 Changelog

See full changelog [here](./CHANGELOG.md)

---

## 🧰 CLI Reference

### 🔧 Options

| Flag / Command    | Description                                      |
|-------------------|--------------------------------------------------|
| `<vmid>`          | ID of the VM or LXC container to inspect         |
| `--version`       | Show installed version of `nodeinfo`             |
| `--vlan`          | Edit VLAN name mappings                          |
| `--ssh`           | Open SSH config file for editing                 |
| `update`          | Check for latest version and download link       |
| `--help`          | Show usage help                                  |
| `--remove`        | Fully remove nodeinfo                            |
| `-y/--yes`        | Skip note overwrite confirmation (not backup)    |
| `--debug`         | Enable debug output and logs                     |

---

### 💡 Examples

- `nodeinfo 100` → Inspect VM 100 and update Notes
- `nodeinfo 202` → Inspect LXC 202 and update Notes
- `nodeinfo 303 -y` → Skip overwrite prompt for container 303 (still prompts for backup)

---

## 🧾 Repo Structure

| Path                        | Purpose                                      |
|-----------------------------|----------------------------------------------|
| `.github/workflows/`        | GitHub Actions for building & releasing      |
| `Makefile`                  | Build automation for `.deb` release          |
| `nodeinfo/DEBIAN/control`   | Package metadata                             |
| `nodeinfo/DEBIAN/postinst`  | Post-install VLAN setup                      |
| `usr/local/bin/nodeinfo`    | Main executable                              |
| `usr/local/bin/share/...`   | Markdown templates (coming soon)             |

> 💡 Only `usr/local/bin/nodeinfo` is included in the installed package.

---
