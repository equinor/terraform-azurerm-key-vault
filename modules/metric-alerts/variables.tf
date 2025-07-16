# TODO(@hknutsen): Should this be a list of vault IDs?
variable "vault_id" {
  type = string
}

variable "action_group_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
