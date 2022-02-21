variable "app_name" {
  type = string
}

variable "environment_name" {
  type = string
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
    secrets      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  }
}
