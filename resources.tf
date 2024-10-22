resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "proxmox_lxc" "microk8s" {
  vmid            = var.vmid
  target_node     = var.target_node
  hostname        = "${var.node_name}-${var.vmid}"
  ostemplate      = "local:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
  unprivileged    = false
  start           = false
  cores           = var.resources.cores
  memory          = var.resources.memory
  onboot          = true
  ssh_public_keys = join("\n", concat([tls_private_key.private_key.public_key_openssh], var.ssh_public_keys))
  description     = <<-EOT
    ## Description
    MicroK8s Cluster Node
    ## Features
    - Nesting: true
    - Fuse: true
    ## Network
    - Name: ${var.network.name}
    - Bridge: ${var.network.bridge}
    - IP: ${var.network.ip == "" ? "192.168.1.4${var.vmid + 1}/24" : var.network.ip}
    - GW: ${var.network.gw}
    - Hostname: ${var.node_name}-${var.vmid}.local
    ## RootFS
    - Storage: ${var.rootfs.storage}
    - Size: ${var.rootfs.size}
  EOT

  features {
    nesting = true
    fuse    = true
  }

  rootfs {
    storage = var.rootfs.storage
    size    = var.rootfs.size
  }

  dynamic "mountpoint" {
    for_each = var.mountpoints
    content {
      key     = tostring(mountpoint.key)
      slot    = mountpoint.key
      storage = mountpoint.value.storage
      mp      = mountpoint.value.mountpoint
      size    = mountpoint.value.size
    }
  }

  network {
    name   = var.network.name
    bridge = var.network.bridge
    ip     = var.network.ip == "" ? "192.168.1.4${var.vmid + 1}/24" : var.network.ip
    gw     = var.network.gw
  }

  # configure LXC container
  provisioner "remote-exec" {
    when = create
    inline = [
      "pct set ${var.vmid} -swap 0",
      "echo 'lxc.apparmor.profile: unconfined' >> /etc/pve/lxc/${var.vmid}.conf",
      "echo 'lxc.cap.drop: ' >> /etc/pve/lxc/${var.vmid}.conf",
      "echo 'lxc.mount.auto: proc:rw sys:rw' >> /etc/pve/lxc/${var.vmid}.conf",
      "echo 'lxc.mount.entry: /dev/fuse dev/fuse none bind,create=file 0 0' >> /etc/pve/lxc/${var.vmid}.conf",
      "echo 'lxc.mount.entry: /sys/kernel/security sys/kernel/security none bind,create=file 0 0' >> /etc/pve/lxc/${var.vmid}.conf",
      "pct start ${var.vmid}",
      "pct exec ${var.vmid} -- bash -c '${data.template_file.rc_local_sh.rendered}'",
      "pct stop ${var.vmid}",
      "pct start ${var.vmid}",
    ]

    connection {
      type     = "ssh"
      user     = var.proxmox_ssh.username
      password = var.proxmox_ssh.password
      host     = var.proxmox_ssh.host
    }
  }

  # configure microk8s and addons
  provisioner "remote-exec" {
    when   = create
    inline = [data.template_file.post_create_sh.rendered]
    connection {
      type        = "ssh"
      user        = "root"
      private_key = tls_private_key.private_key.private_key_pem
      host        = local.host
    }
  }

  provisioner "remote-exec" {
    when   = create
    inline = ["microk8s status --wait-ready"]
    connection {
      type        = "ssh"
      user        = "root"
      private_key = tls_private_key.private_key.private_key_pem
      host        = local.host
    }
  }
}

resource "null_resource" "mountpoint_permission" {
  count = length(var.mountpoints) > 0 ? 1 : 0

  triggers = {
    hash = md5(data.template_file.argocd_install.rendered),
    host = local.host
  }

  provisioner "remote-exec" {
    when = create
    inline = [
      for mountpoint in var.mountpoints : <<-EOT
        pct exec ${var.vmid} -- bash -c "chmod 777 ${mountpoint.mountpoint}"
      EOT
    ]

    connection {
      type     = "ssh"
      user     = var.proxmox_ssh.username
      password = var.proxmox_ssh.password
      host     = var.proxmox_ssh.host
    }
  }

  lifecycle {
    replace_triggered_by = [proxmox_lxc.microk8s]
  }

  depends_on = [
    proxmox_lxc.microk8s
  ]
}

resource "null_resource" "argocd_install" {
  count = var.cluster_addons.argocd.enabled ? 1 : 0

  triggers = {
    hash = md5(data.template_file.argocd_install.rendered),
    host = local.host
  }

  provisioner "remote-exec" {
    inline = [data.template_file.argocd_install.rendered]
    connection {
      type        = "ssh"
      user        = "root"
      private_key = tls_private_key.private_key.private_key_pem
      host        = local.host
    }
  }

  lifecycle {
    replace_triggered_by = [proxmox_lxc.microk8s]
  }

  depends_on = [
    proxmox_lxc.microk8s,
    null_resource.mountpoint_permission
  ]
}

resource "null_resource" "microk8s_add_node" {
  count = length(var.add_cluster_nodes) > 0 ? 1 : 0

  provisioner "remote-exec" {
    inline = [
      for token in var.add_cluster_nodes : <<-EOT
        /snap/bin/${token}
      EOT
    ]
    connection {
      type        = "ssh"
      user        = "root"
      private_key = tls_private_key.private_key.private_key_pem
      host        = local.host
    }
  }

  depends_on = [
    proxmox_lxc.microk8s,
    null_resource.argocd_install
  ]
}
