module "infrastructure" {
  source = "../modules/infrastructure"

  environment                        = var.environment
  resource_group_name                = var.resource_group_name
  location                           = var.location
  servicebus_namespace_name          = var.servicebus_namespace_name
  servicebus_queue_name              = var.servicebus_queue_name
  cosmosdb_account_name              = var.cosmosdb_account_name
  cosmosdb_database_name             = var.cosmosdb_database_name
  cosmosdb_servicebus_container_name = var.cosmosdb_servicebus_container_name
  container_registry_name            = var.container_registry_name
  container_app_environment_name     = var.container_app_environment_name
  user_assigned_identity_name        = var.user_assigned_identity_name
  container_app_name                 = var.container_app_name
  container_image                    = var.container_image
  github_actions_identity_name       = var.github_actions_identity_name
  github_repo                        = var.github_repo
  github_environment                 = var.github_environment
  eventhub_namespace_name            = var.eventhub_namespace_name
  eventhub_hub_name                  = var.eventhub_hub_name
  eventhub_consumer_group_name       = var.eventhub_consumer_group_name
  storage_account_name               = var.storage_account_name
  storage_container_name             = var.storage_container_name
  cosmosdb_eventhub_container_name   = var.cosmosdb_eventhub_container_name
}
