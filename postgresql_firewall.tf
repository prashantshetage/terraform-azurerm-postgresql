// Sets up Postgresql firewall rule
//**********************************************************************************************
resource "azurerm_postgresql_firewall_rule" "firewall_rule" {
  for_each            = var.allowed_cidrs
  name                = "${local.firewall_rule}-${each.key}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql.name
  start_ip_address    = cidrhost(each.value, 0)
  end_ip_address      = cidrhost(each.value, -1)
}
//**********************************************************************************************