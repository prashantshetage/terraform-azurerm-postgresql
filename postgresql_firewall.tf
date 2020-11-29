// Sets up Postgresql firewall rule
//**********************************************************************************************
resource "azurerm_postgresql_firewall_rule" "firewall_rule" {
  for_each            = var.pgserver_count >= 1 ? var.allowed_cidrs : {}
  name                = "${local.firewall_rule}-${each.key}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql[0].name
  start_ip_address    = cidrhost(each.value, 0)
  end_ip_address      = cidrhost(each.value, -1)
}
//**********************************************************************************************


// Sets up Postgresql firewall rule
//**********************************************************************************************
resource "azurerm_postgresql_firewall_rule" "firewall_rule_replica" {
  for_each            = var.pgserver_count >= 1 && length(var.pgserver_replica_locations) >= 1 ? var.allowed_cidrs : {}
  name                = "${local.firewall_rule}-${each.key}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_replica[0].name
  start_ip_address    = cidrhost(each.value, 0)
  end_ip_address      = cidrhost(each.value, -1)
}
//**********************************************************************************************