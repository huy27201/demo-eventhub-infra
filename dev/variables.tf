variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, prod)"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
}

variable "servicebus_namespace_name" {
  type        = string
  description = "Name of the Service Bus namespace"
}

variable "servicebus_queue_name" {
  type        = string
  description = "Name of the Service Bus queue"
}

variable "cosmosdb_account_name" {
  type        = string
  description = "Name of the Cosmos DB account"
}

variable "cosmosdb_database_name" {
  type        = string
  description = "Name of the Cosmos DB SQL database"
}

variable "cosmosdb_servicebus_container_name" {
  type        = string
  description = "Name of the Cosmos DB SQL container for Service Bus messages"
}

variable "container_registry_name" {
  type        = string
  description = "Name of the Azure Container Registry"
}

variable "container_app_environment_name" {
  type        = string
  description = "Name of the Container App environment"
}

variable "user_assigned_identity_name" {
  type        = string
  description = "Name of the user-assigned managed identity"
}

variable "container_app_name" {
  type        = string
  description = "Name of the Container App"
}

variable "container_image" {
  type        = string
  description = "Full container image reference (registry/image:tag)"
}

variable "github_actions_identity_name" {
  type        = string
  description = "Name of the user-assigned managed identity for GitHub Actions"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository in owner/repo format (e.g. my-org/my-repo). Used for OIDC federation."
}

variable "github_environment" {
  type        = string
  description = "GitHub Actions environment name used for OIDC federation (e.g. dev, prod)"
}

variable "eventhub_namespace_name" {
  type        = string
  description = "Name of the Event Hubs namespace"
}

variable "eventhub_hub_name" {
  type        = string
  description = "Name of the Event Hub"
}

variable "eventhub_consumer_group_name" {
  type        = string
  description = "Name of the Event Hub consumer group"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the Storage Account used for Event Hubs checkpointing"
}

variable "storage_container_name" {
  type        = string
  description = "Name of the Blob Storage container used for Event Hubs checkpoints"
}

variable "cosmosdb_eventhub_container_name" {
  type        = string
  description = "Name of the Cosmos DB SQL container for Event Hub messages"
}
