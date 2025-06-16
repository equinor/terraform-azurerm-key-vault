resource "random_id" "name_suffix" {
  byte_length = 8
}

resource "random_uuid" "subscription_id" {}

resource "random_uuid" "tenant_id" {}

locals {
  name_suffix         = random_id.name_suffix.hex
  resource_group_name = "rg-${local.name_suffix}"
}
