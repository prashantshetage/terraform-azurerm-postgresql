// Sets up virtual network rule for postgresql server
//**********************************************************************************************
resource "azurerm_postgresql_virtual_network_rule" "vnet_rule" {
  count                                = length(var.subnet_ids)
  name                                 = "${local.vnet_rule}-${count.index}"
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.postgresql.name
  subnet_id                            = element(var.subnet_ids, count.index)
  ignore_missing_vnet_service_endpoint = var.ignore_missing_vnet_service_endpoint
}
//**********************************************************************************************