locals {
  # Automatically set account tier for BlockBlobStorage/FileStorage if not specified.
  #   Not correcting incompatible type if specified to prevent user misunderstanding.
  account_tier = (var.account_tier == null ? (var.account_kind == "BlockBlobStorage" || var.account_kind == "FileStorage" ? "Premium" : "Standard") : var.account_tier)

  //containers      = defaults(var.containers, var.container_defaults)
  container_blobs = flatten([for k, v in var.containers : [for kb, vb in defaults(v.blobs, { type = "Block" }) : merge(vb, { container_key = k, blob_key = kb })]])

  share_dirs = flatten([for k, v in var.shares : [for kd, vd in v.dirs : merge(vd, { share_key = k, dir_key = kd })]])
  dir_files  = flatten([for k, v in var.shares : [for kd, vd in v.dirs : [for kf, vf in vd.files : merge(vf, { share_key = k, dir_key = kd, file_key = kf })]]])
}
