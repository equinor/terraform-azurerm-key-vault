variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
}

variable "scopes" {
  description = "A list of scopes (resource IDs) to run the log queries at."
  type        = list(string)
}

variable "action_group_ids" {
  description = "A list of action group IDs to send alerts to."
  type        = list(string)
}

variable "certificate_near_expiry_alert_rule_name" {
  description = "The name of this Certificate Near Expiry alert rule."
  type        = string
  default     = "Certificate Near Expiry Alert"
}

variable "secret_near_expiry_alert_rule_name" {
  description = "The name of this Secret Near Expiry alert rule."
  type        = string
  default     = "Secret Near Expiry Alert"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
