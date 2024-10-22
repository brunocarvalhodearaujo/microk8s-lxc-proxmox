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
| <a name="input_proxmox_ssh"></a> [proxmox\_ssh](#input\_proxmox\_ssh) | The network configuration for the Kubernetes cluster. | <pre>object({<br>    host     = string<br>    username = string<br>    password = string<br>  })</pre> | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | The resources to allocate to the Kubernetes cluster nodes. | <pre>object({<br>    cores  = number<br>    memory = number<br>  })</pre> | <pre>{<br>  "cores": 4,<br>  "memory": 8192<br>}</pre> | no |
| <a name="input_rootfs"></a> [rootfs](#input\_rootfs) | The root filesystem configuration for the Kubernetes cluster nodes. | <pre>object({<br>    storage = string<br>    size    = string<br>  })</pre> | <pre>{<br>  "size": "80G",<br>  "storage": "local-lvm"<br>}</pre> | no |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | The SSH public keys to add to the Kubernetes cluster nodes. | `list(string)` | n/a | yes |
| <a name="input_target_node"></a> [target\_node](#input\_target\_node) | The proxmox target node to deploy the Kubernetes cluster to. | `string` | n/a | yes |
| <a name="input_vmid"></a> [vmid](#input\_vmid) | The VMID to assign to the Kubernetes master node. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_add_node_token"></a> [add\_node\_token](#output\_add\_node\_token) | n/a |
| <a name="output_ingress_url"></a> [ingress\_url](#output\_ingress\_url) | The URL of the Ingress controller |
| <a name="output_ip"></a> [ip](#output\_ip) | The IP address of the Kubernetes node |
| <a name="output_kubernetes_api_url"></a> [kubernetes\_api\_url](#output\_kubernetes\_api\_url) | The URL of the Ingress controller |
| <a name="output_kubernetes_token"></a> [kubernetes\_token](#output\_kubernetes\_token) | The URL of the Ingress controller |
| <a name="output_vmid"></a> [vmid](#output\_vmid) | The VMID of the node |

<!--- END_TF_DOCS --->

## References

- [automated kubernetes proxmox](https://github.com/matthieuml/automated-kubernetes-proxmox/blob/main/proxmox/deploy.sh)
- [Installing microk8s in an LXC container](https://gist.github.com/acj/3cb5674670e6145fa4f355b3239165c7)
