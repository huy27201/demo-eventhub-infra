output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.infrastructure.resource_group_name
}

output "eventhub_namespace_id" {
  description = "ID of the Event Hubs namespace"
  value       = module.infrastructure.eventhub_namespace_id
}

output "eventhub_id" {
  description = "ID of the Event Hub"
  value       = module.infrastructure.eventhub_id
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = module.infrastructure.storage_account_id
}

output "checkpoint_container_name" {
  description = "Name of the blob container used for Event Hub checkpointing"
  value       = module.infrastructure.checkpoint_container_name
}

output "cosmosdb_account_id" {
  description = "ID of the Cosmos DB account"
  value       = module.infrastructure.cosmosdb_account_id
}

output "cosmosdb_endpoint" {
  description = "Endpoint of the Cosmos DB account"
  value       = module.infrastructure.cosmosdb_endpoint
}

output "cosmosdb_database_name" {
  description = "Name of the Cosmos DB SQL database"
  value       = module.infrastructure.cosmosdb_database_name
}

output "cosmosdb_container_name" {
  description = "Name of the Cosmos DB SQL container"
  value       = module.infrastructure.cosmosdb_container_name
}

output "container_registry_login_server" {
  description = "Login server URL of the Container Registry"
  value       = module.infrastructure.container_registry_login_server
}

output "container_app_environment_id" {
  description = "ID of the Container App environment"
  value       = module.infrastructure.container_app_environment_id
}

output "user_assigned_identity_id" {
  description = "ID of the user-assigned managed identity"
  value       = module.infrastructure.user_assigned_identity_id
}

output "user_assigned_identity_client_id" {
  description = "Client ID of the user-assigned managed identity"
  value       = module.infrastructure.user_assigned_identity_client_id
}

output "container_app_id" {
  description = "ID of the Container App"
  value       = module.infrastructure.container_app_id
}

output "github_actions_identity_id" {
  description = "ID of the GitHub Actions user-assigned managed identity"
  value       = module.infrastructure.github_actions_identity_id
}

output "github_actions_identity_client_id" {
  description = "Client ID of the GitHub Actions identity — set as AZURE_CLIENT_ID in GitHub Actions secrets"
  value       = module.infrastructure.github_actions_identity_client_id
}
