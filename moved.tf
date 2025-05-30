moved {
  from = azurerm_key_vault.this
  to   = module.vault.azurerm_key_vault.this
}

moved {
  from = azurerm_monitor_diagnostic_setting.this
  to   = module.vault.azurerm_monitor_diagnostic_setting.this
}
