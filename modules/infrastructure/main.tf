resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
  }
}

resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  name                = var.servicebus_namespace_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_servicebus_queue" "servicebus_queue" {
  name              = var.servicebus_queue_name
  namespace_id      = azurerm_servicebus_namespace.servicebus_namespace.id
}

resource "azurerm_servicebus_namespace_authorization_rule" "keda_scaler" {
  name         = "keda-scaler"
  namespace_id = azurerm_servicebus_namespace.servicebus_namespace.id
  listen       = true
  send         = true
  manage       = true
}

resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                = var.eventhub_namespace_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_eventhub" "eventhub_hub" {
  name              = var.eventhub_hub_name
  namespace_id      = azurerm_eventhub_namespace.eventhub_namespace.id
  partition_count   = 2
  message_retention = 1
}

resource "azurerm_storage_account" "checkpoint_store" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "checkpoints" {
  name                  = var.storage_container_name
  storage_account_id    = azurerm_storage_account.checkpoint_store.id
}

resource "azurerm_cosmosdb_account" "data_store" {
  name                = var.cosmosdb_account_name
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

  tags = {
    environment = var.environment
  }
}

resource "azurerm_cosmosdb_sql_database" "app_db" {
  name                = var.cosmosdb_database_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.data_store.name
}

resource "azurerm_cosmosdb_sql_container" "servicebus_messages" {
  name                = var.cosmosdb_servicebus_container_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.data_store.name
  database_name       = azurerm_cosmosdb_sql_database.app_db.name
  partition_key_paths = ["/id"]
}

resource "azurerm_cosmosdb_sql_container" "eventhub_messages" {
  name                = var.cosmosdb_eventhub_container_name
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.data_store.name
  database_name       = azurerm_cosmosdb_sql_database.app_db.name
  partition_key_paths = ["/id"]
}

resource "azurerm_container_registry" "registry" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_user_assigned_identity" "receiver_identity" {
  name                = var.user_assigned_identity_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  tags = {
    environment = var.environment
  }
}

resource "azurerm_user_assigned_identity" "github_actions" {
  name                = var.github_actions_identity_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  tags = {
    environment = var.environment
  }
}

resource "azurerm_federated_identity_credential" "github_actions" {
  name      = "github-actions-${var.environment}"
  parent_id = azurerm_user_assigned_identity.github_actions.id
  audience  = ["api://AzureADTokenExchange"]
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:${var.github_repo}:environment:${var.github_environment}"
}

resource "azurerm_role_assignment" "receiver_servicebus_access" {
  scope                = azurerm_servicebus_namespace.servicebus_namespace.id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_user_assigned_identity.receiver_identity.principal_id
}

resource "azurerm_role_assignment" "receiver_eventhub_access" {
  scope                = azurerm_eventhub_namespace.eventhub_namespace.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = azurerm_user_assigned_identity.receiver_identity.principal_id
}

resource "azurerm_role_assignment" "receiver_storage_access" {
  scope                = azurerm_storage_account.checkpoint_store.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.receiver_identity.principal_id
}

resource "azurerm_cosmosdb_sql_role_assignment" "receiver_data_access" {
  scope               = azurerm_cosmosdb_account.data_store.id
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.data_store.name
  role_definition_id  = "${azurerm_cosmosdb_account.data_store.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = azurerm_user_assigned_identity.receiver_identity.principal_id
}

resource "azurerm_role_assignment" "receiver_registry_access" {
  scope                = azurerm_container_registry.registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.receiver_identity.principal_id
}

resource "azurerm_role_assignment" "github_actions_registry_push" {
  scope                = azurerm_container_registry.registry.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}

resource "azurerm_role_assignment" "github_actions_app_deploy" {
  scope                = azurerm_container_app.receiver.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.github_actions.principal_id
}

resource "azurerm_container_app_environment" "receiver_env" {
  name                = var.container_app_environment_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  identity {
    type = "SystemAssigned"
  }

  workload_profile {
    maximum_count         = 0
    minimum_count         = 0
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_container_app" "receiver" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.receiver_env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  secret {
    name  = "servicebus-connection"
    value = azurerm_servicebus_namespace_authorization_rule.keda_scaler.primary_connection_string
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.receiver_identity.id]
  }

  template {
    min_replicas = 0
    max_replicas = 2

    custom_scale_rule {
      name             = "servicebus-scaler"
      custom_rule_type = "azure-servicebus"
      metadata = {
        namespace    = var.servicebus_namespace_name
        queueName    = var.servicebus_queue_name
        messageCount = "1"
      }
      authentication {
        secret_name       = "servicebus-connection"
        trigger_parameter = "connection"
      }
    }

    container {
      name   = var.container_app_name
      image  = var.container_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.receiver_identity.client_id
      }
      env {
        name  = "SPRING_CLOUD_AZURE_CREDENTIAL_MANAGED_IDENTITY_ENABLED"
        value = "true"
      }
      env {
        name  = "SPRING_CLOUD_AZURE_SERVICEBUS_NAMESPACE"
        value = var.servicebus_namespace_name
      }
      env {
        name  = "SPRING_CLOUD_AZURE_SERVICEBUS_ENTITY_NAME"
        value = var.servicebus_queue_name
      }
      env {
        name  = "SPRING_CLOUD_AZURE_COSMOS_ENDPOINT"
        value = azurerm_cosmosdb_account.data_store.endpoint
      }
      env {
        name  = "SPRING_CLOUD_AZURE_COSMOS_DATABASE"
        value = var.cosmosdb_database_name
      }
      env {
        name  = "SPRING_CLOUD_AZURE_EVENTHUBS_NAMESPACE"
        value = var.eventhub_namespace_name
      }
      env {
        name  = "SPRING_CLOUD_AZURE_EVENTHUBS_EVENT_HUB_NAME"
        value = var.eventhub_hub_name
      }
      env {
        name  = "SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CONSUMER_GROUP"
        value = var.eventhub_consumer_group_name
      }
      env {
        name  = "SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_ACCOUNT_NAME"
        value = var.storage_account_name
      }
      env {
        name  = "SPRING_CLOUD_AZURE_EVENTHUBS_PROCESSOR_CHECKPOINT_STORE_CONTAINER_NAME"
        value = var.storage_container_name
      }
    }
  }

  registry {
    server   = "${var.container_registry_name}.azurecr.io"
    identity = azurerm_user_assigned_identity.receiver_identity.id
  }

  lifecycle {
    ignore_changes = [
      template[0].container[0].image,
    ]
  }

  tags = {
    environment = var.environment
  }
}
