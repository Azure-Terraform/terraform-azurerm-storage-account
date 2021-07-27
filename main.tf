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
}

resource "azurerm_storage_account_network_rules" "netrule" {
  resource_group_name        = var.resource_group_name
  storage_account_name       = azurerm_storage_account.sa.name
  default_action             = (contains(values(var.access_list), "0.0.0.0/0") ? "Allow" : "Deny")
  ip_rules                   = (contains(values(var.access_list), "0.0.0.0/0") ? [] : values(var.access_list))
  virtual_network_subnet_ids = values(var.service_endpoints)
  bypass                     = var.traffic_bypass
}


##############
# File Share
#############
resource "azurerm_storage_share" "share" {
  for_each = var.shares

  name                 = each.key
  storage_account_name = azurerm_storage_account.sa.name
  quota                = each.value.quota

  dynamic "acl" {
    for_each = try(each.value.acl[*], {})
    content {
      id = uuidv5("url", "${azurerm_storage_account.sa.primary_file_endpoint}/${each.key}")
      dynamic "access_policy" {
        for_each = try(acl.value.access_policy[*], {})
        content {
          permissions = access_policy.value.permissions
          start       = access_policy.value.start
          expiry      = access_policy.value.expiry
        }
      }
    }
  }
}


##########################
# File Share: Directories
#########################
resource "azurerm_storage_share_directory" "directory" {
  for_each = { for dir in local.share_dirs : join(".", [dir.share_key, dir.dir_key]) => dir }

  name                 = each.value.dir_key
  share_name           = azurerm_storage_share.share[each.value.share_key].name
  storage_account_name = azurerm_storage_account.sa.name
}

##########################
# File Share: Files
#########################
resource "azurerm_storage_share_file" "directory_file" {
  for_each = { for file in local.dir_files : join(".", [file.share_key, file.dir_key, file.file_key]) => file }

  name             = each.value.file_key
  storage_share_id = azurerm_storage_share.share[each.value.share_key].id
  path                = azurerm_storage_share_directory.directory[join(".", [each.value.share_key, each.value.dir_key])].name
  source              = each.value.source
  content_type        = each.value.content_type
  content_md5         = each.value.content_md5
  content_disposition = each.value.content_disposition
  metadata            = each.value.metadata
}

##########################
# Blob Storage: Container
#########################
resource "azurerm_storage_container" "container" {
  for_each = var.containers

  name                  = each.key
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = each.value.container_access_type
}

##########################
# Blob Storage: Blob
#########################
resource "azurerm_storage_blob" "blob" {
  for_each = { for blob in local.container_blobs : join(".", [blob.container_key, blob.blob_key]) => blob }

  name                   = each.value.blob_key
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.container[each.value.container_key].name
  type                   = each.value.type
  size                   = each.value.size
  access_tier            = each.value.access_tier
  content_type           = each.value.content_type
  content_md5            = each.value.content_md5
  source                 = each.value.source
  source_content         = each.value.source_content
  source_uri             = each.value.source_uri
  parallelism            = each.value.parallelism
  metadata               = each.value.metadata
}
