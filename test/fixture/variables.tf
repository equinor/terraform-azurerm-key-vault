variable "location" {
  type    = string
  default = "northeurope"
}

variable "firewall_ip_rules" {
  type    = list(string)
  default = []
}
