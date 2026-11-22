
#!/bin/sh
# Redmi AX6000 PBR recovery
# DirectBridge -> br-direct -> 192.168.2.1

set -eu

echo "===== AX6000 PBR Recovery ====="

# Verify PBR
[ -x /etc/init.d/pbr ] || {
    echo "ERROR: PBR is not installed."
    exit 1
}

# Verify network configuration
[ "$(uci -q get network.DirectBridge.device || true)" = "br-direct" ] || {
    echo "ERROR: DirectBridge device mismatch."
    exit 1
}

[ "$(uci -q get network.DirectBridge.gateway || true)" = "192.168.2.1" ] || {
    echo "ERROR: DirectBridge gateway mismatch."
    exit 1
}

# Restore PBR uplink
uci set pbr.config.uplink_interface='DirectBridge'
uci commit pbr

# Enable at boot
/etc/init.d/pbr enable

echo "PBR uplink: $(uci get pbr.config.uplink_interface)"

# Restart service
/etc/init.d/pbr restart

echo "===== Recovery finished ====="
