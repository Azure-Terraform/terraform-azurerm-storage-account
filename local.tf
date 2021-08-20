locals {
  # Automatically set account tier for BlockBlobStorage/FileStorage if not specified.
  #   Not correcting incompatible type if specified to prevent user misunderstanding.
  account_tier           = (var.account_tier == null ? (var.account_kind == "BlockBlobStorage" || var.account_kind == "FileStorage" ? "Premium" : "Standard") : var.account_tier)
  static_website_enabled = (local.validate_static_website) ? [{}] : []

  validate_static_website = ((var.enable_static_website && var.account_kind == "BlockBlobStorage" || var.account_kind == "StorageV2") ?
  true : file("ERROR: Account kind must be BlockBlobStorage or StorageV2 when enabling static website"))
}