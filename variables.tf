// Required Variables
//**********************************************************************************************

variable "pgserver_prefix" {
  type        = string
  description = "(Required) Prefix for Postgresql server name"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the resources"
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists"
}

variable "subnet_ids" {
  type        = list(string)
  description = "(Required) The list of the subnet ids that the PostgreSQL server will be connected to"
  default     = []
}

//**********************************************************************************************


// Optional Variables
//**********************************************************************************************

variable "pgserver_suffix" {
  type        = string
  description = "(Optional) Suffix for Postgresql server name"
  default     = ""
}

/* variable "pgserver_replica_suffix" {
  type        = string
  description = "(Optional) Postgresql replica prefix"
  default     = "replica"
} */

variable "pgserver_georestore_suffix" {
  type        = string
  description = "(Optional) Postgresql replica prefix"
  default     = "georestore"
}

variable "pgserver_count" {
  type        = number
  description = "(Optional) Count for Postgresql Server"
  default     = 1
}

variable "pgserver_georestore_count" {
  type        = number
  description = "(Optional) Count for Postgresql GeoRestore"
  default     = 0
}

variable "pgserver_replica_count" {
  type        = number
  description = "(Optional) Count for Postgresql Replica"
  default     = 1
}

variable "pgserver_replica_locations" {
  type        = list(string)
  description = "(Optional) Postgresql replica locations in case replication is required"
  default     = []
}

variable "pgserver_georestore_locations" {
  type        = list(string)
  description = "(Optional) Postgresql GeoRestore locations in case required"
  default     = []
}

variable "create_mode" {
  type        = string
  description = "(Optional) The creation mode. Can be used to restore or replicate existing servers"
  default     = "Default"
}

variable "creation_source_server_id" {
  type        = string
  description = "(Optional) For creation modes other then default the source server ID to use"
  default     = null
}

variable "sku_name" {
  type        = string
  description = "(Optional) Specifies the SKU Name for this PostgreSQL Server"
  default     = "GP_Gen5_2"
}

variable "server_version" {
  type        = string
  description = "(Optional) Specifies the version of PostgreSQL to use"
  default     = "11"
}

variable "storage_mb" {
  type        = number
  description = "(Optional) Max storage allowed for a server in MB"
  default     = 5120
}

variable "administrator_login" {
  type        = string
  description = "(Optional) The Administrator Login for the PostgreSQL Server"
}

variable "administrator_login_password" {
  type        = string
  description = "(Optional) The Password associated with the administrator_login for the PostgreSQL Server"
}

variable "backup_retention_days" {
  type        = number
  description = "(Optional) Backup retention days for the server, supported values are between 7 and 35 days"
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "(Optional) Turn Geo-redundant server backups on/off."
  default     = true
}

variable "auto_grow_enabled" {
  type        = bool
  description = "(Optional) Enable/Disable auto-growing of the storage."
  default     = true
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "(Optional) Whether or not infrastructure is encrypted for this server."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether or not public network access is allowed for this server."
  default     = true
}

variable "ssl_enforcement_enabled" {
  type        = bool
  description = "(Optional) Specifies if SSL should be enforced on connections."
  default     = true
}

variable "ssl_minimal_tls_version_enforced" {
  type        = string
  description = "(Optional) The mimimun TLS version to support on the sever"
  default     = "TLS1_2"
}

variable "restore_point_in_time" {
  type        = string
  description = "(Optional) When create_mode is PointInTimeRestore the point in time to restore from creation_source_server_id"
  default     = null
}

variable "databases" {
  type = map(object({
    name      = string
    charset   = string
    collation = string
  }))
  description = "(Optional) Name, Charset and Collation settings for Postgresql databases to be created"
  default = {
    database1 = {
      name      = "database1"
      charset   = "UTF8"
      collation = "English_United States.1252"
    }
  }
}

variable "allowed_cidrs" {
  type        = map(string)
  description = "(Optional) Map of CIDR blocks to be whitelisted for Postgresql server"
  default     = {}
}

variable "ignore_missing_vnet_service_endpoint" {
  type        = bool
  description = "(Optional) Should the Virtual Network Rule be created before the Subnet has the Virtual Network Service Endpoint enabled?"
  default     = false
}

variable "value" {
  type        = string
  description = "(Optional) Specifies the value of the PostgreSQL Configuration"
  default     = "on"
}

variable "threat_detection_policy" {
  type = object({
    enabled                    = bool
    disabled_alerts            = list(string)
    email_account_admins       = bool
    email_addresses            = list(string)
    retention_days             = number
    storage_account_access_key = string
    storage_endpoint           = string
  })
  description = "(Optional) Threat detection policy configuration"
  default = {
    enabled                    = false
    disabled_alerts            = []
    email_account_admins       = false
    email_addresses            = []
    retention_days             = null
    storage_account_access_key = null
    storage_endpoint           = null
  }
}

variable "identity" {
  type = object({
    type = string #(Required) The type of identity used for the managed cluster
  })
  description = "(Optional) Managed Identity to interact with Azure APIs"
  default = {
    type = "SystemAssigned"
  }
}

variable "resource_tags" {
  type        = map(string)
  description = "(Optional) Tags for resources"
  default     = {}
}

variable "deployment_tags" {
  type        = map(string)
  description = "(Optional) Tags for deployment"
  default     = {}
}

variable "it_depends_on" {
  type        = any
  description = "(Optional) To define explicit dependencies if required"
  default     = null
}
//**********************************************************************************************


// Local Values
//**********************************************************************************************
locals {
  timeout_duration = "1h"
  postgresql_name  = "${var.pgserver_prefix}${random_string.server_name.result}${var.pgserver_suffix}"
  firewall_rule    = "fw-${local.postgresql_name}"
  vnet_rule        = "vnet-rule-${local.postgresql_name}"
}
//**********************************************************************************************