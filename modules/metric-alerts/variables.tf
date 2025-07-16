# TODO(@hknutsen): Should this be a list of vault IDs?
variable "vault_id" {
  description = "The ID of the Key Vault to create these alerts for."
  type        = string
}

variable "action_group_id" {
  description = "The ID of the action group to send alerts to."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
