variable "network" {
  description = "The network configuration for the Kubernetes cluster."
  type = object({
    name   = string
    bridge = string
    gw     = string
    ip     = string
  })
  validation {
    condition     = length(var.network.ip) > 0
    error_message = "The IP address must be provided."
  }
}

variable "rootfs" {
  description = "The root filesystem configuration for the Kubernetes cluster nodes."
  type = object({
    storage = string
    size    = string
  })
  default = {
    storage = "local-lvm"
    size    = "80G"
  }
}

variable "mountpoints" {
  description = "The mountpoints to create on the Kubernetes cluster nodes."
  type = list(object({
    storage    = string
    size       = string
    mountpoint = string
  }))
  default = [
    // { storage = "local-lvm", mountpoint = "/storage", size = "80G" }
  ]
}

variable "proxmox_ssh" {
  description = "The network configuration for the Kubernetes cluster."
  type = object({
    host     = string
    username = string
    password = string
  })
  validation {
    condition     = length(var.proxmox_ssh.host) > 0
    error_message = "The Proxmox host must be provided."
  }
  validation {
    condition     = length(var.proxmox_ssh.username) > 0
    error_message = "The Proxmox username must be provided."
  }
  validation {
    condition     = length(var.proxmox_ssh.password) > 0
    error_message = "The Proxmox password must be provided."
  }
}

variable "resources" {
  description = "The resources to allocate to the Kubernetes cluster nodes."
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 4
    memory = 8192
  }
}

variable "target_node" {
  description = "The proxmox target node to deploy the Kubernetes cluster to."
  type        = string
}

variable "ostemplate" {
  description = "The proxmox template to use for the Kubernetes cluster nodes."
  type        = string
  default     = "local:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
}

variable "node_name" {
  description = "The name to assign to the Kubernetes cluster nodes."
  type        = string
}

variable "vmid" {
  description = "The VMID to assign to the Kubernetes master node."
  type        = number
  nullable    = false
  validation {
    condition     = var.vmid > 0
    error_message = "The target VMID must be greater than 0."
  }
}

variable "cluster_addons" {
  description = "The addons to enable for the Kubernetes cluster."
  type = object({
    ingress = bool
    argocd = object({
      enabled        = bool
      admin_password = string
      ingress_host   = string
    })
  })
  default = {
    ingress = true
    argocd = {
      enabled        = false
      admin_password = ""
      ingress_host   = ""
    }
  }
  validation {
    condition     = !var.cluster_addons.argocd.enabled || length(var.cluster_addons.argocd.admin_password) > 0
    error_message = "An admin password must be provided for ArgoCD."
  }
}

variable "master_vmid" {
  description = "The VMID to assign to the Kubernetes master node."
  type        = number
  nullable    = true
  default     = null
}

variable "ssh_public_keys" {
  description = "The SSH public keys to add to the Kubernetes cluster nodes."
  type        = list(string)
  validation {
    condition     = length(var.ssh_public_keys) > 0
    error_message = "At least one SSH public key must be provided."
  }
}

variable "add_cluster_nodes" {
  description = "The list of VMIDs to add to the Kubernetes cluster."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "The tags to assign to the Kubernetes cluster nodes."
  type        = list(string)
  default     = []
}
