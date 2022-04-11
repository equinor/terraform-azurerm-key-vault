variable "application" {
  description = "The application to create the resources for."
  type        = string
}

variable "environment" {
  description = "The environment to create the resources for."
  type        = string
}

variable "key_vault_name" {
  description = "Specifies the name of the Key Vault."
  type        = string
  default     = null
}

variable "location" {
  description = "Specifies the supported Azure location where the resources exist."
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

variable "client_secret_permissions" {
  description = "List of secret permissions for the current Client."
  type        = list(string)
  default     = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
}

variable "client_certificate_permissions" {
  description = "List of certificate permissions for the current Client."
  type        = list(string)
  default     = []
}

variable "client_key_permissions" {
  description = "List of key permissions for the current Client."
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
  type        = string
}
