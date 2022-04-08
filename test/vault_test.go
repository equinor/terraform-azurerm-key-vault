package test

import (
	"math/rand"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

const application = "terratest"
const environments = 1000

func TestKeyVaultWithSecret(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/key-vault-with-secret",

		Vars: map[string]interface{}{
			"application": application,
			"environment": rand.Intn(environments),
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}

func TestKeyVaultWithCustomName(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/key-vault-with-custom-name",

		Vars: map[string]interface{}{
			"application": application,
			"environment": rand.Intn(environments),
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}
