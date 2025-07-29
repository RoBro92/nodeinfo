#!/usr/bin/env python3

import subprocess
import sys
import datetime

def run_cmd(cmd):
    """Safely run a shell command and return output."""
    try:
        return subprocess.check_output(cmd, stderr=subprocess.DEVNULL).decode().strip()
    except subprocess.CalledProcessError:
        return "Unavailable"

def get_vm_type(vmid):
    """Detect whether it's a QEMU VM or LXC container."""
    if run_cmd(["qm", "status", vmid]) != "Unavailable":
        return "qemu"
    elif run_cmd(["pct", "status", vmid]) != "Unavailable":
        return "lxc"
    else:
        print(f"❌ Error: VM/CT ID {vmid} not found.")
        sys.exit(1)

def get_hostname(vmid, vmtype):
    if vmtype == "lxc":
        return run_cmd(["pct", "exec", vmid, "--", "hostname"])
    return f"vm-{vmid}"

def get_os(vmid, vmtype):
    if vmtype == "lxc":
        os_release = run_cmd(["pct", "exec", vmid, "--", "grep", "^PRETTY_NAME=", "/etc/os-release"])
        return os_release.split("=")[1].strip('"') if "=" in os_release else "Unknown"
    return "VM (not directly accessible)"

def generate_markdown(vmid, vmtype, hostname, os_name):
    today = datetime.date.today().isoformat()
    return f"""## 🖥️ Container/VM Information
- **Hostname**: `{hostname}`
- **Type**: `{vmtype}`
- **Operating System**: {os_name}

## 🔒 Access & Credentials
- **Web UI URL**: 
- **SSH Access**: Enabled
  - **SSH Port**: 22
  - **SSH Key Auth**: Check sshd_config

---

## 🔄 Update Process
- **Service Update Method**: 
- **Last Update**: {today}
- **Update Notes**: *(e.g. manual restart required after update)*

---

## ⚠️ Issues & Fixes

| Date       | Issue                         | Fix / Workaround                    |
|------------|-------------------------------|-------------------------------------|
| {today} | Example issue                 | Description of how you fixed it     |
"""

def update_notes(vmid, vmtype, markdown):
    if vmtype == "lxc":
        config_path = f"/etc/pve/lxc/{vmid}.conf"
        try:
            with open(config_path, "r") as f:
                lines = f.readlines()

            # Strip old notes (any line starting with '# === nodeinfo ===')
            lines = [line for line in lines if not line.startswith("# === nodeinfo ===")]

            # Add new notes
            new_notes = [f"# === nodeinfo === {line.strip()}\n" for line in markdown.splitlines()]
            new_config = new_notes + lines

            with open(config_path, "w") as f:
                f.writelines(new_config)

            print(f"✅ Notes written to {config_path}")
        except Exception as e:
            print(f"❌ Failed to write LXC notes: {e}")
    else:
        subprocess.run(["qm", "set", vmid, "--notes", markdown])

def main():
    if len(sys.argv) != 2:
        print("Usage: nodeinfo <vmid>")
        sys.exit(1)

    vmid = sys.argv[1]
    vmtype = get_vm_type(vmid)
    hostname = get_hostname(vmid, vmtype)
    os_name = get_os(vmid, vmtype)
    markdown = generate_markdown(vmid, vmtype, hostname, os_name)
    update_notes(vmid, vmtype, markdown)

    print(f"✅ Notes updated for {vmtype.upper()} ID {vmid}")

if __name__ == "__main__":
    main()