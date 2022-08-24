# Basic example

Terraform configuration which creates an Azure Key vault with the following features:

- 90 days soft delete retention
- Purge protection disabled
- Full access to secrets (except purging) for current client
- Firewall rules enabled
- Send logs and metrics to Log Analytics workspace
