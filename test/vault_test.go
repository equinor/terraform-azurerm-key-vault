package test

import (
	"math/rand"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

const application = "terratest"
const environments = 1000000

func TestBasicUsageExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic-usage",

		Vars: map[string]interface{}{
			"application": application,
			"environment": rand.Intn(environments),
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}

func TestSecretExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/secret",

		Vars: map[string]interface{}{
			"application": application,
			"environment": rand.Intn(environments),
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}

func TestCustomNameExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/custom-name",

		Vars: map[string]interface{}{
			"application": application,
			"environment": rand.Intn(environments),
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}
