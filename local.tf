locals {
  # Automatically set account tier for BlockBlobStorage/FileStorage if not specified.
  #   Not correcting incompatible type if specified to prevent user misunderstanding.
  account_tier           = (var.account_tier == null ? (var.account_kind == "BlockBlobStorage" || var.account_kind == "FileStorage" ? "Premium" : "Standard") : var.account_tier)
  static_website_enabled = (local.validate_static_website) ? [{}] : []

  validate_static_website = (var.enable_static_website ? ((var.account_kind == "BlockBlobStorage" || var.account_kind == "StorageV2") ?
  true : file("ERROR: Account kind must be BlockBlobStorage or StorageV2 when enabling static website")) : false)

  validate_nfsv3 = (!var.nfsv3_enabled || (var.nfsv3_enabled && var.enable_hns) ?
  true : file("ERROR: NFS V3 can only be enabled when Hierarchical Namespaces are enabled"))

  validate_sftp = (!var.enable_sftp || (var.enable_sftp && var.enable_hns) ?
  true : file("ERROR: SFTP can only be enabled when Hierarchical Namespaces are enabled"))

  validate_nfsv3_network_rules = (!var.nfsv3_enabled || (var.nfsv3_enabled && lower(var.default_network_rule) == "deny") ?
  true : file("ERROR: Default network rule must be Deny when using NFS V3"))

  validate_network_rules = ((lower(var.default_network_rule) == "deny" && var.access_list == {} && var.service_endpoints == {}) ?
  file("ERROR: Storage account does not allow any ingress traffic. Storage account will not be managable after creation") : true)

  validate_encryption_rules = ((var.infrastructure_encryption_enabled && var.account_kind != "StorageV2") ?
  file("ERROR: Infrastructure encryption can only be enabled when account kind is StorageV2") : true)
}
