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

  is_hns_enabled                    = var.enable_hns
  sftp_enabled                      = var.enable_sftp
  large_file_share_enabled          = var.enable_large_file_share
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  https_traffic_only_enabled        = var.https_traffic_only_enabled
  min_tls_version                   = var.min_tls_version
  nfsv3_enabled                     = var.nfsv3_enabled
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  shared_access_key_enabled         = var.shared_access_key_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  allowed_copy_scope                = var.allowed_copy_scope
  identity {
    type = "SystemAssigned"
  }

  dynamic "blob_properties" {
    for_each = ((var.account_kind == "BlockBlobStorage" || var.account_kind == "StorageV2") ? [1] : [])
    content {
      versioning_enabled       = var.blob_versioning_enabled
      last_access_time_enabled = var.blob_last_access_time_enabled

      dynamic "delete_retention_policy" {
        for_each = (var.blob_delete_retention_days == 0 ? [] : [1])
        content {
          days = var.blob_delete_retention_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = (var.container_delete_retention_days == 0 ? [] : [1])
        content {
          days = var.container_delete_retention_days
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

  network_rules {
    default_action             = var.default_network_rule
    ip_rules                   = values(var.access_list)
    virtual_network_subnet_ids = values(var.service_endpoints)
    bypass                     = var.traffic_bypass
  }
}
## azure reference https://docs.microsoft.com/en-us/azure/storage/common/infrastructure-encryption-enable?tabs=portal
resource "azurerm_storage_encryption_scope" "scope" {
  for_each = var.encryption_scopes

  name                               = each.key
  storage_account_id                 = azurerm_storage_account.sa.id
  source                             = coalesce(each.value.source, "Microsoft.Storage")
  infrastructure_encryption_required = coalesce(each.value.enable_infrastructure_encryption, var.infrastructure_encryption_enabled)
}


resource "azurerm_role_assignment" "smb_contributor" {
  for_each = toset(var.smb_contributors)

  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage File Data SMB Share Contributor"
  principal_id         = each.value
}

resource "azurerm_storage_share" "ss" {
  for_each = try({ for s in var.storage_shares : s.name => s }, {})

  storage_account_id = azurerm_storage_account.sa.id

  name  = each.key
  quota = each.value.quota

  enabled_protocol = try(each.value.enabled_protocol, "SMB")
  metadata         = each.value.metadata

  dynamic "acl" {
    for_each = each.value.acl != null ? each.value.acl : []

    content {
      id = acl.value.id

      access_policy {
        permissions = acl.value.access_policy.permissions
        start       = acl.value.access_policy.start
        expiry      = acl.value.access_policy.expiry
      }
    }
  }

  lifecycle {
    precondition {
      condition     = each.value.enabled_protocol == "NFS" ? var.account_tier == "Premium" : true
      error_message = "NFS file shares can only be enabled on Premium Storage Accounts."
    }
    precondition {
      condition     = var.account_tier != "Premium" || each.value.quota >= 100
      error_message = "File share quota must be at least 100Gb for Premium Storage Accounts."
    }
  }
  depends_on = [azurerm_storage_account.sa, azurerm_role_assignment.smb_contributor]
}

resource "azurerm_storage_share_file" "sf" {
  for_each = {
    for fs in local.share_files : fs.file_name => fs
  }
  name             = each.value.file_name
  storage_share_id = each.value.storage_share_url
  source           = each.value.local_path
  content_type     = each.value.content_type
  content_md5      = filemd5(each.value.local_path)
  depends_on       = [azurerm_storage_account.sa, azurerm_storage_share.ss]
}

resource "azurerm_storage_queue" "queues" {
  for_each = var.queue_names != [] ? toset(var.queue_names) : []

  name               = each.key
  storage_account_id = azurerm_storage_account.sa.id
  metadata           = lookup(var.queue_metadata_map, each.key, {})

}
