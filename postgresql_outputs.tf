output "postgresql_server" {
  value = local.postgresql_server_object
}

output "postgresql_server_replica" {
  value = local.postgresql_replica_object
}

output "postgresql_database" {
  value = azurerm_postgresql_database.database
}

