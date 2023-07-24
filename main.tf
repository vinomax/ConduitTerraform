resource "azurerm_resource_group" "rg_name" {
  name     = var.rg_name
  location = var.location
}
resource "azurerm_postgresql_flexible_server" "postgres_server" {
  name                = var.db_server_name
  resource_group_name = azurerm_resource_group.rg_name.name
  location            = var.location
  sku_name            = "GP_Standard_D4s_v3"  # Adjust the SKU according to your requirements
  storage_mb          = 32768            # Adjust the storage size as needed
  backup_retention_days = 7             # Adjust the backup retention period
  version             = "13"
  # public_network_access_enabled = true
  administrator_login     = "postgres"
  administrator_password  = "Pass$123"  # Replace with your desired password
  depends_on = [ azurerm_resource_group.rg_name ]
}
resource "azurerm_postgresql_flexible_server_firewall_rule" "db_firewall" {
  name                = "AllowAll"
  # resource_group_name = azurerm_resource_group.rg_name.name
  # server_name         = azurerm_postgresql_flexible_server.postgres_server.name
  server_id           = azurerm_postgresql_flexible_server.postgres_server.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
  depends_on = [ azurerm_postgresql_flexible_server.postgres_server ]
}
# Container registry setup
resource "azurerm_container_registry" "container_registry" {
  name                = "conduitregistry"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Basic"  # Change to "Standard" for more advanced features
  admin_enabled = true  # Set to false if you don't want admin access for the container registry
  depends_on = [ azurerm_resource_group.rg_name ]
}
