# TODO(@hknutsen): Should this be a list of vault IDs?
variable "vault_id" {
  type     = string
  nullable = false
}

variable "action_group_ids" {
  type     = list(string)
  nullable = false
}

variable "tags" {
  type     = map(string)
  nullable = false
  default  = {}
}
