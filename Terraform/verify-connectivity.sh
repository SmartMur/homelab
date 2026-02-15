#!/bin/bash
# Connectivity Verification Script
# Run from macBook to verify all hosts are reachable

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     Proxmox HA ARR Stack - Connectivity Verification          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

HOSTS=(
  "192.168.100.100:root:Proxmox Node 1 (alpha)"
  "192.168.100.200:root:Proxmox Node 2 (pve)"
  "192.168.13.83:root:Pi4 (murzpi)"
)

PASSED=0
FAILED=0

for HOST_INFO in "${HOSTS[@]}"; do
  IFS=':' read -r IP USER DESC <<< "$HOST_INFO"
  
  echo "Testing: $DESC"
  echo "  IP: $IP"
  
  # Test ping
  if ping -c 1 -W 2 "$IP" > /dev/null 2>&1; then
    echo "  ✅ Ping: OK"
  else
    echo "  ❌ Ping: FAILED"
    FAILED=$((FAILED + 1))
    continue
  fi
  
  # Test SSH
  if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USER@$IP" "echo 'SSH OK'" > /dev/null 2>&1; then
    echo "  ✅ SSH: OK"
  else
    echo "  ❌ SSH: FAILED"
    FAILED=$((FAILED + 1))
    continue
  fi
  
  # Get hostname
  HOSTNAME=$(ssh -o ConnectTimeout=5 "$USER@$IP" "hostname" 2>/dev/null)
  echo "  ✅ Hostname: $HOSTNAME"
  
  # Get kernel version
  KERNEL=$(ssh -o ConnectTimeout=5 "$USER@$IP" "uname -r" 2>/dev/null)
  echo "  ✅ Kernel: $KERNEL"
  
  PASSED=$((PASSED + 1))
  echo ""
done

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                      Summary                                   ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║ Passed: $PASSED/3                                                  ║"
echo "║ Failed: $FAILED/3                                                  ║"

if [ $FAILED -eq 0 ]; then
  echo "║                                                                ║"
  echo "║ ✅ All hosts are reachable and accessible!                    ║"
  echo "║                                                                ║"
  echo "║ You are ready to proceed with:                                ║"
  echo "║ 1. QDevice HA setup (setup-qdevice-ha.sh)                    ║"
  echo "║ 2. Terraform deployment                                       ║"
  echo "╚════════════════════════════════════════════════════════════════╝"
  exit 0
else
  echo "║                                                                ║"
  echo "║ ❌ Some hosts are not reachable!                              ║"
  echo "║                                                                ║"
  echo "║ Please check:                                                  ║"
  echo "║ - Network connectivity                                         ║"
  echo "║ - SSH key configuration                                        ║"
  echo "║ - Firewall rules                                               ║"
  echo "╚════════════════════════════════════════════════════════════════╝"
  exit 1
fi
