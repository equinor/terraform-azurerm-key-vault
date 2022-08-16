variable "vault_name" {
  description = "The name of this Key Vault."
  type        = string
}

variable "location" {
  description = "The supported Azure location where the resources exist."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "purge_protection_enabled" {
  description = "Is purge protection enabled for this key vault?"
  type        = bool
  default     = false
}

variable "access_policies" {
  description = "A list of access policies for this Key Vault."
  type = list(object({
    object_id               = string
    secret_permissions      = list(string)
    certificate_permissions = list(string)
    key_permissions         = list(string)
  }))
  default = []
}

variable "firewall_ip_rules" {
  description = "A list of IP addresses or CIDR blocks that should be able to access the Key Vault."
  type        = list(string)
  default     = []
}

variable "firewall_subnet_rules" {
  description = "A list of IDs of the subnets that should be able to access the Key Vault."
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to send diagnostics to."
  type        = string
}
