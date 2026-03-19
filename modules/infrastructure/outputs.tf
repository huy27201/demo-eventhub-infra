output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "servicebus_namespace_id" {
  description = "ID of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.servicebus_namespace.id
}

output "servicebus_queue_id" {
  description = "ID of the Service Bus queue"
  value       = azurerm_servicebus_queue.servicebus_queue.id
}

output "eventhub_namespace_id" {
  description = "ID of the Event Hubs namespace"
  value       = azurerm_eventhub_namespace.eventhub_namespace.id
}

output "eventhub_hub_id" {
  description = "ID of the Event Hub"
  value       = azurerm_eventhub.eventhub_hub.id
}

output "storage_account_id" {
  description = "ID of the Storage Account used for Event Hubs checkpointing"
  value       = azurerm_storage_account.checkpoint_store.id
}

output "cosmosdb_account_id" {
  description = "ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.data_store.id
}

output "cosmosdb_endpoint" {
  description = "Endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.data_store.endpoint
}

output "cosmosdb_database_name" {
  description = "Name of the Cosmos DB SQL database"
  value       = azurerm_cosmosdb_sql_database.app_db.name
}

output "cosmosdb_servicebus_container_name" {
  description = "Name of the Cosmos DB SQL container for Service Bus messages"
  value       = azurerm_cosmosdb_sql_container.servicebus_messages.name
}

output "cosmosdb_eventhub_container_name" {
  description = "Name of the Cosmos DB SQL container for Event Hub messages"
  value       = azurerm_cosmosdb_sql_container.eventhub_messages.name
}

output "container_registry_login_server" {
  description = "Login server URL of the Container Registry"
  value       = azurerm_container_registry.registry.login_server
}

output "container_app_environment_id" {
  description = "ID of the Container App environment"
  value       = azurerm_container_app_environment.receiver_env.id
}

output "user_assigned_identity_id" {
  description = "ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.receiver_identity.id
}

output "user_assigned_identity_client_id" {
  description = "Client ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.receiver_identity.client_id
}

output "container_app_id" {
  description = "ID of the Container App"
  value       = azurerm_container_app.receiver.id
}

output "github_actions_identity_id" {
  description = "ID of the GitHub Actions user-assigned managed identity"
  value       = azurerm_user_assigned_identity.github_actions.id
}

output "github_actions_identity_client_id" {
  description = "Client ID of the GitHub Actions identity — set as AZURE_CLIENT_ID in GitHub Actions secrets"
  value       = azurerm_user_assigned_identity.github_actions.client_id
}
