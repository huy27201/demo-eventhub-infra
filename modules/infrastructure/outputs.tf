output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "eventhub_namespace_id" {
  description = "ID of the Event Hubs namespace"
  value       = azurerm_eventhub_namespace.receiver_namespace.id
}

output "eventhub_id" {
  description = "ID of the Event Hub"
  value       = azurerm_eventhub.messages.id
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.checkpoint.id
}

output "cosmosdb_account_id" {
  description = "ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.data_store.id
}

output "cosmosdb_endpoint" {
  description = "Endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.data_store.endpoint
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
