variable "vault_ids" {
  description = "A list of IDs of Key Vaults to create alerts for."
  type        = list(string)
}

variable "action_group_ids" {
  description = "A list of IDs of action groups to send alerts to."
  type        = list(string)
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
