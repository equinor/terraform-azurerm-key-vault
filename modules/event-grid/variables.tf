variable "system_topic_name" {
  description = "The name of this Event Grid system topic."
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

variable "key_vault_id" {
  description = "The ID of the Key Vault to create this Event Grid system topic for."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to."
  type        = string
}

variable "event_subscriptions" {
  description = "A map of event subscription to create for this Event Grid system topic."

  type = map(object({
    name = string

    included_event_types = optional(list(string), [
      "Microsoft.KeyVault.CertificateNearExpiry",
      "Microsoft.KeyVault.CertificateExpired",
      "Microsoft.KeyVault.KeyNearExpiry",
      "Microsoft.KeyVault.KeyExpired",
      "Microsoft.KeyVault.SecretNearExpiry",
      "Microsoft.KeyVault.SecretExpired"
    ])

    azure_function_endpoint = object({
      function_id = string
    })
  }))

  default = {}
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
