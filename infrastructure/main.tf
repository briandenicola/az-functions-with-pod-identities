data "azurerm_client_config" "current" {}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length = 1
  separator  = ""
}

locals {
    location                    = "southcentralus"
    resource_name               = "${random_pet.this.id}-${random_id.this.dec}"
    storage_account_name        = "${random_pet.this.id}${random_id.this.dec}sa"
    aks_name                    = "${local.resource_name}-aks"
    eventhub_name               = "${local.resource_name}-eventhub"
}

resource "azurerm_resource_group" "this" {
  name                  = "${local.resource_name}_rg"
  location              = local.location
  
  tags     = {
    Application = "event-processor"
    Components  = "aks; functions; workload-identities"
    DeployedOn  = timestamp()
  }
}