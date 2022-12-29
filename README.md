# Azure Key Vault Terraform module

Terraform module which creates an Azure Key vault.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | A list of access policies for this Key vault. | <pre>list(object({<br>    object_id               = string<br>    secret_permissions      = optional(list(string), [])<br>    certificate_permissions = optional(list(string), [])<br>    key_permissions         = optional(list(string), [])<br>  }))</pre> | `[]` | no |
| <a name="input_diagnostic_setting_name"></a> [diagnostic\_setting\_name](#input\_diagnostic\_setting\_name) | The name of this diagnostic setting. | `string` | `"audit-logs"` | no |
| <a name="input_location"></a> [location](#input\_location) | The location to create the resources in. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID of the Log Analytics workspace to send diagnostics to. | `string` | n/a | yes |
| <a name="input_network_acls_bypass_azure_services"></a> [network\_acls\_bypass\_azure\_services](#input\_network\_acls\_bypass\_azure\_services) | Should Azure services be able to bypass the network ACL and access this Key vault? | `bool` | `true` | no |
| <a name="input_network_acls_ip_rules"></a> [network\_acls\_ip\_rules](#input\_network\_acls\_ip\_rules) | A list of IP addresses or CIDR blocks that should be able to bypass the network ACL and access this Key vault. | `list(string)` | `[]` | no |
| <a name="input_network_acls_virtual_network_subnet_ids"></a> [network\_acls\_virtual\_network\_subnet\_ids](#input\_network\_acls\_virtual\_network\_subnet\_ids) | A list of Virtual Network subnet IDs that should be able to bypass the network ACL and access this Key vault. | `list(string)` | `[]` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | Is purge protection enabled for this Key vault? | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group to create the resources in. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. | `map(string)` | `{}` | no |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | The name of this Key vault. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vault_id"></a> [vault\_id](#output\_vault\_id) | The ID of this Key vault. |
| <a name="output_vault_name"></a> [vault\_name](#output\_vault\_name) | The name of this Key vault. |
| <a name="output_vault_uri"></a> [vault\_uri](#output\_vault\_uri) | The URI of this Key vault. |
<!-- END_TF_DOCS -->
