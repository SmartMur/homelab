#!/bin/bash
# Setup QDevice HA for 2-node Proxmox cluster with Pi4 as witness
# Run this script on ONE of the Proxmox nodes (preferably the first one)
# Pi4 IP: 192.168.13.83
# Pi4 Hostname: murzpi

set -e

QDEVICE_HOST="192.168.13.83"
QDEVICE_HOSTNAME="murzpi"

echo "=========================================="
echo "Proxmox QDevice HA Setup"
echo "=========================================="
echo "QDevice Host: $QDEVICE_HOST ($QDEVICE_HOSTNAME)"
echo ""

# Step 1: Verify qnetd is running on Pi4
echo "[1/5] Verifying qnetd is running on Pi4..."
if ssh root@$QDEVICE_HOST "systemctl is-active corosync-qnetd" | grep -q "active"; then
    echo "✓ qnetd is running on Pi4"
else
    echo "✗ qnetd is NOT running on Pi4. Starting it..."
    ssh root@$QDEVICE_HOST "systemctl enable corosync-qnetd && systemctl start corosync-qnetd"
fi

# Step 2: Verify corosync-qdevice is installed locally
echo ""
echo "[2/5] Verifying corosync-qdevice is installed..."
if dpkg -l | grep -q corosync-qdevice; then
    echo "✓ corosync-qdevice is installed"
else
    echo "✗ Installing corosync-qdevice..."
    apt-get update
    apt-get install -y corosync-qdevice
fi

# Step 3: Add QDevice to corosync configuration
echo ""
echo "[3/5] Configuring QDevice in corosync..."
COROSYNC_CONF="/etc/corosync/corosync.conf"

# Backup original config
cp $COROSYNC_CONF ${COROSYNC_CONF}.backup.$(date +%s)

# Check if qdevice section already exists
if grep -q "qdevice {" $COROSYNC_CONF; then
    echo "✓ QDevice section already exists in corosync.conf"
else
    echo "Adding QDevice configuration..."
    # Add qdevice section before the closing brace
    sed -i '/^}$/i\
qdevice {\
  model: net\
  net {\
    host: '"$QDEVICE_HOST"'\
    algorithm: ffsplit\
    tie_breaker: lowest\
  }\
}' $COROSYNC_CONF
    echo "✓ QDevice configuration added"
fi

# Step 4: Reload corosync configuration
echo ""
echo "[4/5] Reloading corosync configuration..."
corosync-cfgtool -R
sleep 2

# Step 5: Verify QDevice status
echo ""
echo "[5/5] Verifying QDevice status..."
sleep 3

if corosync-qdevice-net status 2>/dev/null | grep -q "Quorum votes"; then
    echo "✓ QDevice is connected and operational"
    corosync-qdevice-net status
else
    echo "⚠ QDevice status check - waiting for connection..."
    sleep 5
    corosync-qdevice-net status || echo "Note: QDevice may still be initializing"
fi

echo ""
echo "=========================================="
echo "Cluster Status:"
echo "=========================================="
pvecm status

echo ""
echo "=========================================="
echo "HA Status:"
echo "=========================================="
ha-manager status

echo ""
echo "✓ QDevice HA setup complete!"
echo ""
echo "Next steps:"
echo "1. Run this script on the second Proxmox node as well"
echo "2. Verify cluster quorum: pvecm status"
echo "3. Check HA status: ha-manager status"
echo "4. Monitor QDevice: corosync-qdevice-net status"
