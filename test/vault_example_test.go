package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestVaultExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/vault-example",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	subscriptionId := terraform.Output(t, terraformOptions, "subscription_id")
	keyVaultId := terraform.Output(t, terraformOptions, "key_vault_id")
	keyVaultSecretName := terraform.Output(t, terraformOptions, "key_vault_secret_name")
	monitorDiagnosticSettingId := terraform.Output(t, terraformOptions, "monitor_diagnostic_setting_id")

	keyVaultName := azure.GetNameFromResourceID(keyVaultId)
	monitorDiagnosticSettingName := azure.GetNameFromResourceID(monitorDiagnosticSettingId)

	azure.KeyVaultSecretExists(t, keyVaultName, keyVaultSecretName)
	azure.DiagnosticSettingsResourceExists(t, monitorDiagnosticSettingName, keyVaultId, subscriptionId)
}
