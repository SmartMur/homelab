# Proxmox 2-Node HA Setup with Pi4 QDevice

## Overview
This guide sets up High Availability for your 2-node Proxmox cluster using the Pi4 as a Quorum Device (QDevice). This provides:
- **Quorum**: 3-node quorum without making Pi4 a full cluster member
- **Failover**: Automatic VM restart on node failure
- **Split-brain prevention**: QDevice breaks ties in network partitions

## Architecture
```
Proxmox Node 1 (192.168.100.100) ─┐
                                   ├─ Corosync Cluster
Proxmox Node 2 (192.168.100.200) ─┤
                                   └─ QDevice: Pi4 (192.168.13.83)
```

## Prerequisites
- ✅ 2 Proxmox nodes in a cluster (Agape)
- ✅ Pi4 with qnetd installed and running
- ✅ Shared storage (PBS, unifiDrive CIFS)
- ✅ SSH key-based access to all hosts

## Current Status
- **Cluster**: 2 nodes (alpha, pve)
- **Quorum**: Currently requires both nodes (2/2 votes)
- **Storage**: PBS, local, local-lvm, unifiDrive (CIFS)
- **Pi4 qnetd**: Running and ready

## Setup Steps

### Step 1: Run Setup Script on Node 1
SSH into Proxmox Node 1 and run the setup script:

```bash
ssh root@192.168.100.100

# Download and run the setup script
curl -O https://your-repo/setup-qdevice-ha.sh
chmod +x setup-qdevice-ha.sh
./setup-qdevice-ha.sh
```

Or manually:
```bash
# Install corosync-qdevice if not present
apt-get update && apt-get install -y corosync-qdevice

# Edit corosync.conf
nano /etc/corosync/corosync.conf

# Add this section before the closing brace:
qdevice {
  model: net
  net {
    host: 192.168.13.83
    algorithm: ffsplit
    tie_breaker: lowest
  }
}

# Reload corosync
corosync-cfgtool -R

# Verify
corosync-qdevice-net status
```

### Step 2: Run Setup Script on Node 2
SSH into Proxmox Node 2 and repeat:

```bash
ssh root@192.168.100.200
./setup-qdevice-ha.sh
```

### Step 3: Verify HA Status

Check cluster status:
```bash
pvecm status
```

Expected output:
```
Quorum information
------------------
Expected votes:   3
Highest expected: 3
Total votes:      3
Quorum:           2
Flags:            Quorate
```

Check QDevice status:
```bash
corosync-qdevice-net status
```

Expected output:
```
Quorum votes:     3
Quorum votes:     3 (local node: 1, qdevice: 1)
```

Check HA status:
```bash
ha-manager status
```

## Firewall Rules (if needed)

Pi4 qnetd uses port 5403/TCP. Ensure it's open:

```bash
# On Pi4
ufw allow 5403/tcp

# On Proxmox nodes (if using UFW)
ufw allow from 192.168.100.100 to any port 5403
ufw allow from 192.168.100.200 to any port 5403
```

## Testing Failover

### Test 1: Verify Quorum with One Node Down
```bash
# On Node 1, stop corosync
systemctl stop corosync

# On Node 2, check quorum
pvecm status
# Should show: Quorate: Yes (because QDevice breaks tie)

# Restart Node 1
systemctl start corosync
```

### Test 2: VM HA Failover
1. Create a test VM on Node 1
2. Enable HA for the VM:
   ```bash
   ha-manager add vm:100 --comment "Test VM"
   ```
3. Stop Node 1 or kill the VM process
4. VM should restart on Node 2 within seconds

## Monitoring

### Watch QDevice Status
```bash
watch -n 2 'corosync-qdevice-net status'
```

### Monitor Cluster Events
```bash
journalctl -u corosync -f
journalctl -u corosync-qdevice -f
```

### Check Corosync Logs
```bash
tail -f /var/log/syslog | grep -i corosync
```

## Troubleshooting

### QDevice Not Connecting
```bash
# Check if qnetd is running on Pi4
ssh root@192.168.13.83 systemctl status corosync-qnetd

# Check connectivity
ssh root@192.168.100.100 nc -zv 192.168.13.83 5403

# Restart qdevice on Proxmox node
systemctl restart corosync-qdevice
```

### Quorum Lost
```bash
# Check cluster status
pvecm status

# If quorum is lost, check:
# 1. Network connectivity between nodes
# 2. QDevice connectivity
# 3. Corosync logs: journalctl -u corosync -n 50
```

### Corosync Configuration Issues
```bash
# Validate corosync.conf syntax
corosync-cfgtool -s

# Check for duplicate sections
grep -n "qdevice {" /etc/corosync/corosync.conf
```

## Rollback (if needed)

If you need to remove QDevice:

```bash
# On both nodes, edit corosync.conf
nano /etc/corosync/corosync.conf

# Remove the qdevice section

# Reload corosync
corosync-cfgtool -R

# Verify
pvecm status
```

## Next Steps: VM HA Configuration

Once QDevice is verified working:

1. **Enable HA for VMs**:
   ```bash
   ha-manager add vm:100 --comment "ARR Stack VM"
   ```

2. **Configure HA Groups** (optional):
   ```bash
   ha-manager add group:arr-group --nodes alpha,pve --comment "ARR Stack Group"
   ```

3. **Monitor HA Resources**:
   ```bash
   ha-manager status
   ```

## References
- [Proxmox HA Documentation](https://pve.proxmox.com/wiki/High_Availability)
- [Corosync QDevice Documentation](https://corosync.github.io/corosync/qdevice/)
- [Proxmox Cluster Documentation](https://pve.proxmox.com/wiki/Cluster_Manager)

## Support
For issues, check:
- Corosync logs: `journalctl -u corosync`
- QDevice logs: `journalctl -u corosync-qdevice`
- Syslog: `/var/log/syslog`
