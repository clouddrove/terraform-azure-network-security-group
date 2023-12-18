# Terraform version
terraform {
  required_version = ">= 1.6.5"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.84.0"
    }
  }
}
