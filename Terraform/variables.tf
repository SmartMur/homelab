variable "proxmox_api_url" {
  description = "Proxmox API URL (e.g., https://192.168.100.100:8006/api2/json)"
  type        = string
}

variable "proxmox_token_id" {
  description = "Proxmox API token ID (e.g., terraform@pam!terraform)"
  type        = string
  sensitive   = true
}

variable "proxmox_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "proxmox_tls_insecure" {
  description = "Disable TLS verification (not recommended for production)"
  type        = bool
  default     = true
}

variable "proxmox_nodes" {
  description = "List of Proxmox nodes for HA distribution"
  type        = list(string)
  default     = ["alpha", "pve"]
}

variable "proxmox_storage" {
  description = "Storage backend for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "proxmox_storage_iso" {
  description = "Storage backend for ISO/templates"
  type        = string
  default     = "local"
}

variable "vm_template_id" {
  description = "Template VM ID to clone from (must be cloud-init enabled)"
  type        = number
  default     = 9000
}

variable "vm_count" {
  description = "Number of ARR stack VMs to create"
  type        = number
  default     = 2
}

variable "vm_cpu" {
  description = "Number of CPU cores per VM"
  type        = number
  default     = 4
}

variable "vm_memory" {
  description = "Memory in MB per VM"
  type        = number
  default     = 4096
}

variable "vm_disk_size" {
  description = "Disk size in GB per VM"
  type        = number
  default     = 50
}

variable "vm_bridge" {
  description = "Network bridge for VMs"
  type        = string
  default     = "vmbr0"
}

variable "vm_vlan_tag" {
  description = "VLAN tag for VM network (0 = no VLAN)"
  type        = number
  default     = 0
}

variable "vm_ip_type" {
  description = "IP configuration: 'dhcp' or 'static'"
  type        = string
  default     = "dhcp"
  validation {
    condition     = contains(["dhcp", "static"], var.vm_ip_type)
    error_message = "vm_ip_type must be 'dhcp' or 'static'."
  }
}

variable "vm_ip_subnet" {
  description = "Subnet for static IPs (e.g., 192.168.1.0/24)"
  type        = string
  default     = "192.168.1.0/24"
}

variable "vm_ip_gateway" {
  description = "Gateway IP for static IPs"
  type        = string
  default     = "192.168.1.1"
}

variable "vm_dns_servers" {
  description = "DNS servers for VMs"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "vm_ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "vm_timezone" {
  description = "Timezone for VMs"
  type        = string
  default     = "UTC"
}

variable "docker_registry_mirror" {
  description = "Docker registry mirror URL (optional)"
  type        = string
  default     = ""
}

variable "github_repo_url" {
  description = "GitHub repository URL for homemedia stack"
  type        = string
  default     = "https://github.com/sugarayhkins/homemedia.git"
}

variable "github_repo_branch" {
  description = "GitHub repository branch"
  type        = string
  default     = "main"
}

variable "arr_compose_path" {
  description = "Path to docker-compose file in the repo (relative to repo root)"
  type        = string
  default     = "docker-compose.yml"
}

variable "arr_storage_path" {
  description = "Host path for ARR config and media storage"
  type        = string
  default     = "/srv/media"
}

variable "arr_config_path" {
  description = "Host path for ARR application configs"
  type        = string
  default     = "/srv/config"
}

variable "enable_ha" {
  description = "Enable Proxmox HA for VMs"
  type        = bool
  default     = true
}

variable "ha_group" {
  description = "HA group name for VMs"
  type        = string
  default     = "arr-stack"
}

variable "tags" {
  description = "Tags for VMs"
  type        = list(string)
  default     = ["arr-stack", "ha", "docker"]
}
