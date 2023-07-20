resource "azapi_resource" "aca_env" {
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  parent_id = azurerm_resource_group.rg_name.id
  location  = azurerm_resource_group.rg_name.location
  name      = var.container_env
  }

resource "azapi_resource" "aca" {
  for_each = { for ca in var.container_apps : ca.name => ca }

  type      = "Microsoft.App/containerApps@2022-03-01"
  parent_id = azurerm_resource_group.rg_name.id
  location  = azurerm_resource_group.rg_name.location
  name      = each.value.name
  body = jsonencode({
    properties : {
      managedEnvironmentId = azapi_resource.aca_env.id
      configuration = {
        ingress = {
          external   = each.value.ingress_enabled
          targetPort = each.value.ingress_enabled ? each.value.containerPort : null
        }
      }
      template = {
        containers = [
          {
            name  = "main"
            image = "${each.value.image}:${each.value.tag}"
            resources = {
              cpu    = each.value.cpu_requests
              memory = each.value.mem_requests
            }
          }
        ]
        scale = {
          minReplicas = each.value.min_replicas
          maxReplicas = each.value.max_replicas
        }
      }
    }
  })
}
resource "azurerm_log_analytics_workspace" "log_storage" {
  name                = "law-aca-terraform"
  resource_group_name = azurerm_resource_group.rg_name.name
  location            = azurerm_resource_group.rg_name.location
  sku                 = "PerGB2018"
  retention_in_days   = 90
}
resource "azapi_resource" "aca_log" {
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  parent_id = azurerm_resource_group.rg_name.id
  location  = azurerm_resource_group.rg_name.location
  name      = "aca-env-terraform"
  
  body   = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination               = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.log_storage.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.log_storage.primary_shared_key
        }
      }
    }
 })
}