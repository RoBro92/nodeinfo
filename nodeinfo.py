#!/usr/bin/env python3

import subprocess
import sys
import datetime
import os
import re

def run_cmd(cmd):
    try:
        return subprocess.check_output(cmd, stderr=subprocess.DEVNULL).decode().strip()
    except:
        return "Unavailable"

def get_vm_type(vmid):
    if run_cmd(["qm", "status", vmid]) != "Unavailable":
        return "qemu"
    elif run_cmd(["pct", "status", vmid]) != "Unavailable":
        return "lxc"
    else:
        print(f"❌ VM/CT ID {vmid} not found.")
        sys.exit(1)

def get_hostname(vmid, vmtype):
    if vmtype == "lxc":
        return run_cmd(["pct", "exec", vmid, "--", "hostname"])
    return f"vm-{vmid}"

def get_os(vmid, vmtype):
    if vmtype == "lxc":
        output = run_cmd(["pct", "exec", vmid, "--", "cat", "/etc/os-release"])
        for line in output.splitlines():
            if line.startswith("PRETTY_NAME="):
                return line.split("=")[1].strip('"')
    return "VM (OS not directly accessible)"

def get_network_info(vmid, vmtype):
    if vmtype == "lxc":
        conf_path = f"/etc/pve/lxc/{vmid}.conf"
    else:
        conf_path = f"/etc/pve/qemu-server/{vmid}.conf"

    ip = "Unknown"
    vlan = "Unknown"

    try:
        with open(conf_path, "r") as f:
            for line in f:
                if line.startswith("net0"):
                    if "ip=" in line:
                        match = re.search(r"ip=([\d\.\/]+)", line)
                        if match:
                            ip = match.group(1).split("/")[0]
                    if "tag=" in line:
                        match = re.search(r"tag=(\d+)", line)
                        if match:
                            vlan = match.group(1)
    except:
        pass

    if ip == "Unknown":
        if vmtype == "lxc":
            try:
                ip = run_cmd(["pct", "exec", vmid, "--", "hostname", "-I"]).split()[0]
            except:
                pass
        else:
            try:
                output = run_cmd(["qm", "agent", vmid, "exec", "--", "ip", "a"])
                for line in output.splitlines():
                    if "inet " in line and "127." not in line:
                        ip = line.strip().split()[1].split("/")[0]
                        break
            except:
                pass

    return ip, vlan

def generate_markdown(vmid, vmtype, hostname, os_name, ip, vlan):
    today = datetime.date.today().isoformat()

    return f"""🖥️ **Container/VM Information**

- **Hostname**: {hostname}
- **Type**: {vmtype}
- **Operating System**: {os_name}
- **IP Address**: {ip}
- **VLAN/Subnet**: {vlan} – {vlan_to_name(vlan)}

🔒 **Access & Credentials**

- **Web UI URL**: http://{ip}
- **SSH Access**: Enabled
  - **SSH Port**: 22
  - **SSH Key Auth**: Check sshd_config

🔄 **Update Process**

- **Service Update Method**: 
- **Last Update**: {today}
- **Update Notes**: *(e.g. manual restart required after update)*

⚠️ **Issues & Fixes**

| Date       | Issue         | Fix / Workaround              |
|------------|---------------|-------------------------------|
| {today} | Example issue | Description of how you fixed it |
"""

def vlan_to_name(vlan):
    mapping = {
        "9": "Infrastructure",
        "10": "Hypervisors",
        "20": "Media",
    }
    return mapping.get(vlan, "Unknown")

def update_notes(vmid, vmtype, markdown):
    if vmtype == "lxc":
        config_path = f"/etc/pve/lxc/{vmid}.conf"
        try:
            with open(config_path, "r") as f:
                lines = f.readlines()

            # Remove old nodeinfo block
            start = None
            end = None
            for i, line in enumerate(lines):
                if line.strip() == "# === nodeinfo start ===":
                    start = i
                elif line.strip() == "# === nodeinfo end ===":
                    end = i
                    break

            if start is not None and end is not None:
                del lines[start:end + 1]

            # Clean new note block
            new_notes = [f"# {line}\n" for line in markdown.splitlines()]
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
    ip, vlan = get_network_info(vmid, vmtype)

    markdown = generate_markdown(vmid, vmtype, hostname, os_name, ip, vlan)
    update_notes(vmid, vmtype, markdown)
    print(f"✅ Notes updated for {vmtype.upper()} ID {vmid}")

if __name__ == "__main__":
    main()