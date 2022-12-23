variable "vault_name" {
  description = "The name of this Key vault."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
}

variable "purge_protection_enabled" {
  description = "Is purge protection enabled for this Key vault?"
  type        = bool
  default     = false
}

variable "access_policies" {
  description = "A list of access policies for this Key vault."
  type = list(object({
    object_id               = string
    secret_permissions      = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    key_permissions         = optional(list(string), [])
  }))
  default = []
}

variable "network_acls_ip_rules" {
  description = "A list of IP addresses or CIDR blocks that should be able to bypass the network ACL and access this Key vault."
  type        = list(string)
  default     = []
}

variable "network_acls_virtual_network_subnet_ids" {
  description = "A list of Virtual Network subnet IDs that should be able to bypass the network ACL and access this Key vault."
  type        = list(string)
  default     = []
}

variable "network_acls_bypass_azure_services" {
  description = "Should Azure services be able to bypass the network ACL and access this Key vault?"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
