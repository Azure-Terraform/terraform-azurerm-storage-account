

resource "random_string" "random" {
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa" {
  name                     = (var.name == null ? random_string.random.result : var.name)
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.account_kind
  account_tier             = local.account_tier
  account_replication_type = var.replication_type
  access_tier              = var.access_tier
  tags                     = var.tags

  is_hns_enabled           = var.enable_hns
  large_file_share_enabled = var.enable_large_file_share

  allow_blob_public_access  = var.allow_blob_public_access
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version

  identity {
    type = "SystemAssigned"
  }

  dynamic "blob_properties" {
    for_each = (var.account_kind == "BlockBlobStorage" ? [1] : [])
    content {
      dynamic "delete_retention_policy" {
        for_each = (var.blob_delete_retention_days == null ? [] : [1])
        content {
          days = var.blob_delete_retention_days
        }
      }
      dynamic "cors_rule" {
        for_each = (var.blob_cors == null ? {} : var.blob_cors)
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = local.static_website_enabled
    content {
      index_document     = var.index_path
      error_404_document = var.custom_404_path
    }
  }
}

resource "azurerm_storage_account_network_rules" "netrule" {
  resource_group_name        = var.resource_group_name
  storage_account_name       = azurerm_storage_account.sa.name
  default_action             = (contains(values(var.access_list), "0.0.0.0/0") ? "Allow" : "Deny")
  ip_rules                   = (contains(values(var.access_list), "0.0.0.0/0") ? [] : values(var.access_list))
  virtual_network_subnet_ids = values(var.service_endpoints)
  bypass                     = var.traffic_bypass
}

