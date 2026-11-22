
#!/bin/sh
# Redmi AX6000 PBR recovery
# DirectBridge -> br-direct -> 192.168.2.1

set -eu

echo "===== AX6000 PBR Recovery ====="

# Verify PBR installation
if [ ! -x /etc/init.d/pbr ]; then
    echo "ERROR: PBR is not installed."
    exit 1
fi

# Verify DirectBridge device
if [ "$(uci -q get network.DirectBridge.device)" != "br-direct" ]; then
    echo "ERROR: DirectBridge device mismatch."
    exit 1
fi

# Verify DirectBridge gateway
if [ "$(uci -q get network.DirectBridge.gateway)" != "192.168.2.1" ]; then
    echo "ERROR: DirectBridge gateway mismatch."
    exit 1
fi

# Configure PBR uplink
uci set pbr.config.uplink_interface='DirectBridge'
uci commit pbr

# Enable PBR at boot
/etc/init.d/pbr enable

echo "PBR uplink: $(uci get pbr.config.uplink_interface)"

# Restart PBR
/etc/init.d/pbr restart

echo
echo "===== PBR Status ====="
/etc/init.d/pbr status

echo
echo "===== Recovery completed ====="
