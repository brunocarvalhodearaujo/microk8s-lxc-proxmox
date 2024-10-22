data "template_file" "post_create_sh" {
  template = file("${path.module}/scripts/post_create.sh.tpl")
  vars = {
    ingress_install = tostring(var.cluster_addons.ingress)
  }
}

data "template_file" "rc_local_sh" {
  template = file("${path.module}/scripts/rc.local.sh.tpl")
}

data "template_file" "argocd_install" {
  template = file("${path.module}/scripts/argocd_install.sh.tpl")
  vars = {
    argocd_admin_password = var.cluster_addons.argocd.admin_password
    argocd_ingress_host   = var.cluster_addons.argocd.enabled ? var.cluster_addons.argocd.ingress_host : ""
  }
}

data "template_file" "master_node_join" {
  template = file("${path.module}/scripts/master_node_join.sh.tpl")
  vars = {
    master_vmid = var.master_vmid != null ? var.master_vmid : ""
    vmid        = var.vmid
  }
}

data "external" "microk8s_api_token" {
  program = ["bash", "${path.module}/scripts/generate-k8s-token.sh"]
  query = {
    user        = "root"
    private_key = tls_private_key.private_key.private_key_pem
    host        = local.host
  }
  depends_on = [
    proxmox_lxc.microk8s
  ]
}

data "external" "microk8s_join_token" {
  program = ["bash", "${path.module}/scripts/join-k8s-token.sh"]
  query = {
    user        = "root"
    private_key = tls_private_key.private_key.private_key_pem
    host        = local.host
  }
  depends_on = [
    proxmox_lxc.microk8s
  ]
}
