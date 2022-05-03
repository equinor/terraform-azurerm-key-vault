package test

import (
	"io"
	"net/http"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

const TerraformDir = "./fixture"

func TestTerraformVault(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: TerraformDir,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}

func TestTerraformVaultFirewall(t *testing.T) {
	// Get public IP address
	resp, err := http.Get("https://ifconfig.me/")
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
	ip, err := io.ReadAll(resp.Body)
	if err != nil {
		panic(err)
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: TerraformDir,

		Vars: map[string]interface{}{
			"firewall_ip_rules": []string{string(ip)},
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}
