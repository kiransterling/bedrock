/**
 * # Rancher stack configuration
 *
 * Provision a stack on a Rancher server instance.
 */
data "rancher_environment" "environment" {
  name = var.environment
}

resource "rancher_stack" "catalog_stack" {
  count           = replace(replace(length(var.catalog_id) > 0, "/true/", 1), "/false/", 0)
  environment_id  = data.rancher_environment.environment.id
  name            = var.stack_name
  catalog_id      = var.catalog_id
  start_on_create = true
}

resource "rancher_stack" "stack" {
  count           = replace(replace(length(var.catalog_id) > 0, "/false/", 1), "/true/", 0)
  environment_id  = data.rancher_environment.environment.id
  name            = var.stack_name
  docker_compose  = file(var.docker_compose)
  rancher_compose = file(var.rancher_compose)
  start_on_create = true
}
