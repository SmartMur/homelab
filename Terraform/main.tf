# Main Terraform Configuration for ARR Stack HA VMs

# Data source to get template VM
data "proxmox_vm_qemu" "template" {
  name = "cloud-init-template"
  vmid = var.vm_template_id
}

# Local variables for VM naming and distribution
locals {
  vm_base_name = "arr-stack"
  nodes        = var.proxmox_nodes
  node_count   = length(local.nodes)
}

# Create ARR Stack VMs distributed across nodes
resource "proxmox_vm_qemu" "arr_stack" {
  count = var.vm_count

  name        = "${local.vm_base_name}-${count.index + 1}"
  vmid        = 100 + count.index
  target_node = local.nodes[count.index % local.node_count]
  clone       = data.proxmox_vm_qemu.template.name
  full_clone  = false

  # CPU and Memory
  cores   = var.vm_cpu
  sockets = 1
  memory  = var.vm_memory

  # Disk
  disk {
    slot     = 0
    size     = "${var.vm_disk_size}G"
    type     = "scsi"
    storage  = var.proxmox_storage
    iothread = 1
  }

  # Network
  network {
    model  = "virtio"
    bridge = var.vm_bridge
    tag    = var.vm_vlan_tag != 0 ? var.vm_vlan_tag : null
  }

  # Cloud-init
  ciuser     = "root"
  cipassword = "placeholder"  # Will be overridden by SSH key
  sshkeys    = var.vm_ssh_public_key

  # Cloud-init user data
  user_data = base64encode(templatefile("${path.module}/templates/user-data.yaml", {
    hostname           = "${local.vm_base_name}-${count.index + 1}"
    timezone           = var.vm_timezone
    ssh_public_key     = var.vm_ssh_public_key
    docker_mirror      = var.docker_registry_mirror
    github_repo_url    = var.github_repo_url
    github_repo_branch = var.github_repo_branch
    arr_compose_path   = var.arr_compose_path
    arr_storage_path   = var.arr_storage_path
    arr_config_path    = var.arr_config_path
  }))

  # Cloud-init network config
  network_config = base64encode(templatefile("${path.module}/templates/network-config.yaml", {
    ip_type    = var.vm_ip_type
    ip_address = var.vm_ip_type == "static" ? cidrhost(var.vm_ip_subnet, 100 + count.index) : null
    ip_prefix  = var.vm_ip_type == "static" ? split("/", var.vm_ip_subnet)[1] : null
    gateway    = var.vm_ip_type == "static" ? var.vm_ip_gateway : null
    dns_servers = join(",", var.vm_dns_servers)
  }))

  # VM Options
  onboot = true
  agent  = 1

  # Tags
  tags = join(";", var.tags)

  # Lifecycle
  lifecycle {
    ignore_changes = [
      cipassword,
      user_data,
      network_config
    ]
  }

  depends_on = [data.proxmox_vm_qemu.template]
}

# Enable HA for VMs (optional)
resource "proxmox_virtual_environment_ha_resource" "arr_stack" {
  count = var.enable_ha ? var.vm_count : 0

  resource_id = "vm:${proxmox_vm_qemu.arr_stack[count.index].vmid}"
  state       = "started"
  group       = var.ha_group
  comment     = "ARR Stack VM ${count.index + 1}"
}

# Output VM information
output "vm_info" {
  description = "Information about created VMs"
  value = [
    for vm in proxmox_vm_qemu.arr_stack : {
      name        = vm.name
      vmid        = vm.vmid
      node        = vm.target_node
      cpu         = vm.cores
      memory      = vm.memory
      disk_size   = var.vm_disk_size
      tags        = var.tags
    }
  ]
}

output "ha_status" {
  description = "HA configuration status"
  value = {
    enabled = var.enable_ha
    group   = var.ha_group
    vms     = var.enable_ha ? [for vm in proxmox_vm_qemu.arr_stack : vm.name] : []
  }
}
