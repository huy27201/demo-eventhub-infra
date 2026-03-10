terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.63.0"
    }
  }

  required_version = ">= 1.14.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "EHubRG"
  location = "southeastasia"
}

resource "azurerm_eventhub_namespace" "ehns" {
  name                = "huygnguyenehubns"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
}

resource "azurerm_eventhub" "eh" {
  name              = "myeventhub"
  namespace_id      = azurerm_eventhub_namespace.ehns.id
  partition_count   = 2
  message_retention = 1
}

resource "azurerm_storage_account" "storage" {
  name                            = "demoehubsa"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
}

resource "azurerm_cosmosdb_account" "cosmos" {
  name                = "demo-huygnguyen-cosmos-db"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  offer_type          = "Standard"

  automatic_failover_enabled = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "huygnguyencontainerregistry"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
}

resource "azurerm_container_app_environment" "aca_env" {
  name                       = "demo-huygnguyen-env"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aca_env_logs.id

  identity {
    type = "SystemAssigned"
  }

  workload_profile {
    maximum_count         = 0
    minimum_count         = 0
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}

resource "azurerm_log_analytics_workspace" "aca_env_logs" {
  name                = "workspaceehubrgb492"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_container_app" "demo-eventhub-receiver" {
  name                         = "demo-eventhub-receiver"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  identity {
    type = "SystemAssigned"
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "demo-eventhub-receiver"
      image  = "huygnguyencontainerregistry.azurecr.io/demo-eventhub-receiver:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  registry {
    server   = "huygnguyencontainerregistry.azurecr.io"
    identity = "system"
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image,
    ]
  }
}

# Assign Role to demo-eventhub-receiver to allow it to read messages from Event Hub
resource "azurerm_role_assignment" "demo-eventhub-receiver_eventhub_role" {
  scope                = azurerm_eventhub_namespace.ehns.id
  role_definition_name = "Azure Event Hubs Data Owner"
  principal_id         = azurerm_container_app.demo-eventhub-receiver.identity[0].principal_id
}

import {
    to = azurerm_role_assignment.demo-eventhub-receiver_eventhub_role
    id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.EventHub/namespaces/${azurerm_eventhub_namespace.ehns.name}/eventhubs/${azurerm_eventhub.eh.name}/Microsoft.Authorization/roleAssignments/${uuid()}"
}
