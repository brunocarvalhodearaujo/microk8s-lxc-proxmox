# MicroK8S on Proxmox via LXC

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.10 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 3.0.1-rc4 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 3.0.1-rc4 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.argocd_install](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.microk8s_add_node](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.mountpoint_permission](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [proxmox_lxc.microk8s](https://registry.terraform.io/providers/Telmate/proxmox/3.0.1-rc4/docs/resources/lxc) | resource |
| [tls_private_key.private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [external_external.microk8s_api_token](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [external_external.microk8s_join_token](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [template_file.argocd_install](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.master_node_join](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.post_create_sh](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.rc_local_sh](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_cluster_nodes"></a> [add\_cluster\_nodes](#input\_add\_cluster\_nodes) | The list of VMIDs to add to the Kubernetes cluster. | `list(string)` | `[]` | no |
| <a name="input_cluster_addons"></a> [cluster\_addons](#input\_cluster\_addons) | The addons to enable for the Kubernetes cluster. | <pre>object({<br>    ingress = bool<br>    argocd = object({<br>      enabled        = bool<br>      admin_password = string<br>      ingress_host   = string<br>    })<br>  })</pre> | <pre>{<br>  "argocd": {<br>    "admin_password": "",<br>    "enabled": false,<br>    "ingress_host": ""<br>  },<br>  "ingress": true<br>}</pre> | no |
| <a name="input_master_vmid"></a> [master\_vmid](#input\_master\_vmid) | The VMID to assign to the Kubernetes master node. | `number` | `null` | no |
| <a name="input_mountpoints"></a> [mountpoints](#input\_mountpoints) | The mountpoints to create on the Kubernetes cluster nodes. | <pre>list(object({<br>    storage    = string<br>    size       = string<br>    mountpoint = string<br>  }))</pre> | `[]` | no |
| <a name="input_network"></a> [network](#input\_network) | The network configuration for the Kubernetes cluster. | <pre>object({<br>    name   = string<br>    bridge = string<br>    gw     = string<br>    ip     = string<br>  })</pre> | n/a | yes |
| <a name="input_node_name"></a> [node\_name](#input\_node\_name) | The name to assign to the Kubernetes cluster nodes. | `string` | n/a | yes |
| <a name="input_ostemplate"></a> [ostemplate](#input\_ostemplate) | The proxmox template to use for the Kubernetes cluster nodes. | `string` | `"local:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"` | no |
| <a name="input_proxmox_ssh"></a> [proxmox\_ssh](#input\_proxmox\_ssh) | The network configuration for the Kubernetes cluster. | <pre>object({<br>    host     = string<br>    username = string<br>    password = string<br>  })</pre> | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | The resources to allocate to the Kubernetes cluster nodes. | <pre>object({<br>    cores  = number<br>    memory = number<br>  })</pre> | <pre>{<br>  "cores": 4,<br>  "memory": 8192<br>}</pre> | no |
| <a name="input_rootfs"></a> [rootfs](#input\_rootfs) | The root filesystem configuration for the Kubernetes cluster nodes. | <pre>object({<br>    storage = string<br>    size    = string<br>  })</pre> | <pre>{<br>  "size": "80G",<br>  "storage": "local-lvm"<br>}</pre> | no |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | The SSH public keys to add to the Kubernetes cluster nodes. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to assign to the Kubernetes cluster nodes. | `list(string)` | `[]` | no |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | The proxmox target node to deploy the Kubernetes cluster to. | `string` | n/a | yes |
| <a name="input_vmid"></a> [vmid](#input\_vmid) | The VMID to assign to the Kubernetes master node. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_add_node_token"></a> [add\_node\_token](#output\_add\_node\_token) | The URL of the Ingress controller |
| <a name="output_ingress_url"></a> [ingress\_url](#output\_ingress\_url) | The URL of the Ingress controller |
| <a name="output_ip"></a> [ip](#output\_ip) | The IP address of the Kubernetes node |
| <a name="output_kubernetes_api_url"></a> [kubernetes\_api\_url](#output\_kubernetes\_api\_url) | The URL of the Ingress controller |
| <a name="output_kubernetes_token"></a> [kubernetes\_token](#output\_kubernetes\_token) | The URL of the Ingress controller |
| <a name="output_vmid"></a> [vmid](#output\_vmid) | The proxmox VMID of the node |

<!--- END_TF_DOCS --->

## Examples

### Single Node

````hcl
module "microk8s_master_node" {
  source      = "github.com/brunocarvalhodearaujo/microk8s-lxc-proxmox"
  target_node = "b550m"
  vmid        = 402
  node_name   = "microk8s-master"
  ostemplate  = "local:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
  ssh_public_keys = [
    var.public_key_openssh,
  ]
  cluster_addons = {
    ingress = true
    argocd = {
      admin_password = "loremipsum"
      enabled        = true
      ingress_host   = "argocd.example.com"
    }
  }
  resources = {
    cores  = 4
    memory = 4096
  }
  rootfs = {
    storage = "local-lvm"
    size    = "80G"
  }
  proxmox_ssh = {
    host     = var.proxmox_host
    username = var.proxmox_username
    password = var.proxmox_password
  }
  network = {
    name   = "eth0"
    bridge = "vmbr0"
    ip6    = "dhcp"
    gw     = "192.168.1.1"
    ip     = "192.168.1.50/24"
  }
}
````

### Multi Node

````hcl
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "microk8s_worker_node" {
  source      = "github.com/brunocarvalhodearaujo/microk8s-lxc-proxmox"
  target_node = "b550m"
  vmid        = 403
  node_name   = "microk8s-worker"
  ostemplate  = "local:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
  ssh_public_keys = [
    tls_private_key.private_key.public_key_openssh
  ]
  resources = {
    cores  = 4
    memory = 4096
  }
  rootfs = {
    storage = "local-lvm"
    size    = "80G"
  }
  proxmox_ssh = {
    host     = var.proxmox_host
    username = var.proxmox_username
    password = var.proxmox_password
  }
  network = {
    name   = "eth0"
    bridge = "vmbr0"
    ip6    = "dhcp"
    gw     = "192.168.1.1"
    ip     = "192.168.1.51/24"
  }
}

module "microk8s_master_node" {
  source      = "github.com/brunocarvalhodearaujo/microk8s-lxc-proxmox"
  target_node = "b550m"
  vmid        = 402
  node_name   = "microk8s-master"
  ostemplate  = "local:vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
  ssh_public_keys = [
    tls_private_key.private_key.public_key_openssh
  ]
  cluster_addons = {
    ingress = true
    argocd = {
      admin_password = "loremipsum"
      enabled        = true
      ingress_host   = "argocd.example.com"
    }
  }
  resources = {
    cores  = 4
    memory = 8192
  }
  rootfs = {
    storage = "local-lvm"
    size    = "80G"
  }
  proxmox_ssh = {
    host     = var.proxmox_host
    username = var.proxmox_username
    password = var.proxmox_password
  }
  add_cluster_nodes = [
    nonsensitive(module.microk8s_worker_node.add_node_token)
  ]
  network = {
    name   = "eth0"
    bridge = "vmbr0"
    ip6    = "dhcp"
    gw     = "192.168.1.1"
    ip     = "192.168.1.50/24"
  }
  depends_on = [
    module.microk8s_worker_node
  ]
}
````

## Integration with kubernetes provider

````hcl
terraform {
  required_version = ">= 1.0.10"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
  }
}

provider "proxmox" {}

module "microk8s_master_node" {
    // put the module configuration here
}

provider "kubernetes" {
  host     = module.microk8s_master_node.kubernetes_api_url
  token    = module.microk8s_master_node.kubernetes_token
  insecure = true
}

resource "kubernetes_namespace" "sample" {
  metadata {
    name = "my-namespace"
  }
}
````

## Integration with cloudflare provider

````hcl
terraform {
  required_version = ">= 1.0.10"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.44.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
  }
}

provider "proxmox" {}

module "microk8s_master_node" {
  // put the module configuration here
}

data "cloudflare_zone" "example" {
  name = "example.com"
}

resource "random_password" "tunnel_secret" {
  length = 64
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "example" {
  account_id = var.cloudflare_account_id
  name       = "example"
  secret     = base64sha256(random_password.tunnel_secret.result)
}

resource "cloudflare_record" "microk8s" {
  zone_id = data.cloudflare_zone.example.id
  name    = "*"
  content = cloudflare_zero_trust_tunnel_cloudflared.example.cname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "b550mk_tunnel" {
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.b550mk.id
  account_id = var.cloudflare_account_id
  config {
    warp_routing {
      enabled = true
    }

    ingress_rule {
      origin_request {
        http2_origin  = true
        no_tls_verify = true
      }
      hostname = cloudflare_record.example.hostname
      service  = module.microk8s_master_node.ingress_url
    }

    ingress_rule {
      service = "http_status:404"
    }
  }
}
````

Then you can access the Kubernetes cluster via the cloudflare record `*.example.com` and the argo web interface via the cloudflare record `argocd.example.com`.

Ingress controller is enabled by default, so you can access the services via the cloudflare record `*.example.com`.

````yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-sample-ingress
  namespace: my-namespace
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
spec:
  ingressClassName: "nginx"
  rules:
    - host: test.example.com
      http:
        paths:
          - pathType: Prefix
            path: /
            backend:
              service:
                name: sample-service
                port:
                  name: http
````

## References

- [automated kubernetes proxmox](https://github.com/matthieuml/automated-kubernetes-proxmox/blob/main/proxmox/deploy.sh)
- [Installing microk8s in an LXC container](https://gist.github.com/acj/3cb5674670e6145fa4f355b3239165c7)
