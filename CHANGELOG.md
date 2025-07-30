#!/bin/sh

CONFIG_FILE="/etc/nodeinfo/vlan.conf"

if [ -t 0 ]; then
    echo -n "Would you like to edit your VLAN names now? (y/n): "
    read answer
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        editor="${EDITOR:-nano}"
        $editor "$CONFIG_FILE"
    else
        echo "ℹ️  You can configure VLAN names later by running: nodeinfo --vlan"
    fi
else
    echo "ℹ️  You can configure VLAN names later by running: nodeinfo --vlan"
fi
