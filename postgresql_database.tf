// Sets up Postgresql database
//**********************************************************************************************
resource "azurerm_postgresql_database" "database" {
  for_each            = var.databases
  name                = each.value.name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql.name
  charset             = each.value.charset
  collation           = each.value.collation
}
//**********************************************************************************************