// Sets up virtual network rule for postgresql server
//**********************************************************************************************
resource "azurerm_postgresql_virtual_network_rule" "vnet_rule" {
  count                                = var.pgserver_count >= 1 ? length(var.subnet_ids) : 0
  name                                 = "${local.vnet_rule}-${count.index}"
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.postgresql[0].name
  subnet_id                            = element(var.subnet_ids, count.index)
  ignore_missing_vnet_service_endpoint = var.ignore_missing_vnet_service_endpoint
}
//**********************************************************************************************


/* // Sets up virtual network rule for postgresql server
//**********************************************************************************************
resource "azurerm_postgresql_virtual_network_rule" "vnet_rule_replica" {
  count                                = length(var.subnet_ids)
  name                                 = "${local.vnet_rule}-${count.index}"
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.postgresql_replica[0].name
  subnet_id                            = element(var.subnet_ids, count.index)
  ignore_missing_vnet_service_endpoint = var.ignore_missing_vnet_service_endpoint
}
//********************************************************************************************** */