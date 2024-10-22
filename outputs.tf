output "ip" {
  description = "The IP address of the Kubernetes node"
  value       = local.host
}

output "vmid" {
  description = "The proxmox VMID of the node"
  value       = var.vmid
}

output "ingress_url" {
  description = "The URL of the Ingress controller"
  value       = "https://${local.host}"
}

output "kubernetes_api_url" {
  description = "The URL of the Ingress controller"
  value       = "https://${local.host}:16443"
}

output "kubernetes_token" {
  description = "The URL of the Ingress controller"
  sensitive   = true
  value       = data.external.microk8s_api_token.result.access_token
}

output "add_node_token" {
  description = "The URL of the Ingress controller"
  sensitive   = true
  value       = data.external.microk8s_join_token.result.token
}
