variable "application" {
  description = "Application name, used to generate resource names"
  type        = string
}

variable "environment" {
  description = "Environment name, used to generate resource names"
  type        = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "key_vault_name" {
  description = "Key vault name, generated if not set"
  type        = string
  default     = null
}

variable "client_permissions" {
  description = "Key vault permissions for current user or service principal"
  type = object({
    certificates = list(string)
    keys         = list(string)
    secrets      = list(string)
  })
  default = {
    certificates = []
    keys         = []
    secrets      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
