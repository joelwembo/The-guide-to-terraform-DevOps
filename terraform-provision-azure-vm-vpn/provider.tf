# Configure the Azure Provider
provider "azurerm" {
  skip_provider_registration = "true"

  # subscription_id = ""
  # client_id       = ""
  # client_secret   = ""
  # tenant_id       = ""
  
  features {
    resource_group {
       prevent_deletion_if_contains_resources = false
     }
  }

}
