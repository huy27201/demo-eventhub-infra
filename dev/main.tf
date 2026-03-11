module "infrastructure" {
  source = "../modules/infrastructure"

  environment                    = var.environment
  resource_group_name            = var.resource_group_name
  location                       = var.location
  eventhub_namespace_name        = var.eventhub_namespace_name
  eventhub_name                  = var.eventhub_name
  storage_account_name           = var.storage_account_name
  checkpoint_container_name      = var.checkpoint_container_name
  cosmosdb_account_name          = var.cosmosdb_account_name
  container_registry_name        = var.container_registry_name
  container_app_environment_name = var.container_app_environment_name
  user_assigned_identity_name    = var.user_assigned_identity_name
  container_app_name             = var.container_app_name
  container_image                = var.container_image
  github_actions_identity_name   = var.github_actions_identity_name
  github_repo                    = var.github_repo
  github_environment             = var.github_environment
}
