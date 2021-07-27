##
# Required parameters
##
variable "name" {
  description = "Storage account name."
  type        = string
  default     = null
}

variable "location" {
  description = "Specifies the supported Azure location to MySQL server resource"
  type        = string
}

variable "resource_group_name" {
  description = "name of the resource group to create the resource"
  type        = string
}

variable "names" {
  description = "names to be applied to resources"
  type        = map(string)
}

variable "tags" {
  description = "tags to be applied to resources"
  type        = map(string)
}

variable "account_kind" {
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
  type        = string
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account (Standard or Premium)."
  type        = string
  default     = null
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts"
  type        = string
  default     = "Hot"

  validation {
    condition     = (contains(["hot", "cool"], lower(var.access_tier)))
    error_message = "The account_tier must be either \"Hot\" or \"Cool\"."
  }
}

variable "replication_type" {
  description = "Storage account replication type - i.e. LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  type        = string
}

variable "enable_large_file_share" {
  description = "Enable Large File Share."
  type        = bool
  default     = false
}

variable "enable_hns" {
  description = "Enable Hierarchical Namespace (can be used with Azure Data Lake Storage Gen 2)."
  type        = bool
  default     = false
}

variable "enable_https_traffic_only" {
  description = "Forces HTTPS if enabled."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account."
  type        = string
  default     = "TLS1_2"
}

variable "allow_blob_public_access" {
  description = "Allow or disallow public access to all blobs or containers in the storage account."
  type        = bool
  default     = false
}

# Note: make sure to include the IP address of the host from where "terraform" command is executed to allow for access to the storage
# Otherwise, creating container inside the storage or any access attempt will be denied.
variable "access_list" {
  description = "Map of CIDRs Storage Account access."
  type        = map(string)
  default     = {}
}

variable "service_endpoints" {
  description = "Creates a virtual network rule in the subnet_id (values are virtual network subnet ids)."
  type        = map(string)
  default     = {}
}

variable "traffic_bypass" {
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None."
  type        = list(string)
  default     = ["None"]
}

variable "blob_delete_retention_days" {
  description = "Retention days for deleted blob. Valid value is between 1 and 365."
  type        = number
  default     = 7
}

variable "blob_cors" {
  description = "blob service cors rules:  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule"
  type = map(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = null
}

variable "shares" {
  description = "Manages a File Share within Azure Storage."
  type = map(object({
    quota = optional(number)

    acl = optional(object({
      access_policy = object({
        permissions = string
        start       = string
        expiry      = string
      })
    }))

    dirs = optional(map(object({
      metadata = optional(map(string))
      files = optional(map(object({
        path                = optional(string)
        source              = optional(string)
        content_type        = optional(string)
        content_md5         = optional(string)
        content_disposition = optional(string)
        metadata            = optional(map(string))
      })))
    })))
  }))
  default = {}
}

variable "containers" {
  description = "Manages a Container within an Azure Storage Account."
  type = map(object({
    container_access_type = optional(string)
    metadata              = optional(map(string))
    blobs = optional(map(object({
      type           = optional(string)
      source         = optional(string)
      size           = optional(number)
      access_tier    = optional(string)
      content_type   = optional(string)
      content_md5    = optional(string)
      source         = optional(string)
      source_content = optional(string)
      source_uri     = optional(string)
      parallelism    = optional(number)
      metadata       = optional(map(string))
    })))
  }))
  default = {}
}
