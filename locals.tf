locals {
  host = split("/", var.network.ip == "" ? "192.168.1.4${var.vmid + 1}/24" : var.network.ip)[0]
}
