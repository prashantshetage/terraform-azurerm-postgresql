// Generate a random string to use in Postgresql server name
//**********************************************************************************************
resource "random_string" "server_name" {
  length  = 4
  special = false
  upper   = false
}
//**********************************************************************************************


// Postgresql server
//**********************************************************************************************
resource "azurerm_postgresql_server" "postgresql" {
  count = var.pgserver_count

  name                = local.postgresql_name
  location            = var.location
  resource_group_name = var.resource_group_name
  create_mode         = var.create_mode

  creation_source_server_id = var.creation_source_server_id

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  sku_name   = var.sku_name
  version    = var.server_version
  storage_mb = var.storage_mb

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  auto_grow_enabled            = var.auto_grow_enabled

  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  ssl_enforcement_enabled           = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced  = var.ssl_minimal_tls_version_enforced

  threat_detection_policy {
    enabled                    = var.threat_detection_policy.enabled
    disabled_alerts            = var.threat_detection_policy.disabled_alerts
    email_account_admins       = var.threat_detection_policy.email_account_admins
    email_addresses            = var.threat_detection_policy.email_addresses
    retention_days             = var.threat_detection_policy.retention_days
    storage_account_access_key = var.threat_detection_policy.storage_account_access_key
    storage_endpoint           = var.threat_detection_policy.storage_endpoint
  }

  tags       = merge(var.resource_tags, var.deployment_tags)
  depends_on = [var.it_depends_on]

  lifecycle {
    ignore_changes = [
      threat_detection_policy,
      tags
    ]
  }

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}
//**********************************************************************************************


// Postgresql Server Replica
//**********************************************************************************************
resource "azurerm_postgresql_server" "postgresql_replica" {
  count               = var.pgserver_count >= 1 ? length(var.pgserver_replica_locations) : 0
  name                = "${local.postgresql_name}-${var.pgserver_replica_suffix}-${element(var.pgserver_replica_locations, count.index)}"
  location            = element(var.pgserver_replica_locations, count.index)
  resource_group_name = var.resource_group_name
  create_mode         = "Replica"

  creation_source_server_id = azurerm_postgresql_server.postgresql[0].id

  sku_name = var.sku_name
  version  = var.server_version

  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced


  tags       = merge(var.resource_tags, var.deployment_tags)
  depends_on = [var.it_depends_on]

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}
//**********************************************************************************************

