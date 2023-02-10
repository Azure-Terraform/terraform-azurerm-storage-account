# Azure - Storage Account Module
This module will create a storage account.

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_encryption_scope.scope](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_encryption_scope) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_list"></a> [access\_list](#input\_access\_list) | Map of CIDRs Storage Account access. | `map(string)` | `{}` | no |
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 | `string` | `"StorageV2"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | Defines the Tier to use for this storage account (Standard or Premium). | `string` | `null` | no |
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Allow or disallow public access to all blobs or containers in the storage account. | `bool` | `false` | no |
| <a name="input_blob_cors"></a> [blob\_cors](#input\_blob\_cors) | blob service cors rules:  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule | <pre>map(object({<br>    allowed_headers    = list(string)<br>    allowed_methods    = list(string)<br>    allowed_origins    = list(string)<br>    exposed_headers    = list(string)<br>    max_age_in_seconds = number<br>  }))</pre> | `null` | no |
| <a name="input_blob_delete_retention_days"></a> [blob\_delete\_retention\_days](#input\_blob\_delete\_retention\_days) | Retention days for deleted blob. Valid value is between 1 and 365 (set to 0 to disable). | `number` | `7` | no |
| <a name="input_blob_versioning_enabled"></a> [blob\_versioning\_enabled](#input\_blob\_versioning\_enabled) | Controls whether blob object versioning is enabled. | `bool` | `false` | no |
| <a name="input_container_delete_retention_days"></a> [container\_delete\_retention\_days](#input\_container\_delete\_retention\_days) | Retention days for deleted container. Valid value is between 1 and 365 (set to 0 to disable). | `number` | `7` | no |
| <a name="input_custom_404_path"></a> [custom\_404\_path](#input\_custom\_404\_path) | path from your repo root to your custom 404 page | `string` | `null` | no |
| <a name="input_default_network_rule"></a> [default\_network\_rule](#input\_default\_network\_rule) | Specifies the default action of allow or deny when no other network rules match | `string` | `"Deny"` | no |
| <a name="input_enable_hns"></a> [enable\_hns](#input\_enable\_hns) | Enable Hierarchical Namespace (can be used with Azure Data Lake Storage Gen 2). | `bool` | `false` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | Forces HTTPS if enabled. | `bool` | `true` | no |
| <a name="input_enable_large_file_share"></a> [enable\_large\_file\_share](#input\_enable\_large\_file\_share) | Enable Large File Share. | `bool` | `false` | no |
| <a name="input_enable_sftp"></a> [enable\_sftp](#input\_enable\_sftp) | Enable SFTP for storage account (enable\_hns must be set to true for this to work). | `bool` | `false` | no |
| <a name="input_enable_static_website"></a> [enable\_static\_website](#input\_enable\_static\_website) | Controls if static website to be enabled on the storage account. Possible values are `true` or `false` | `bool` | `false` | no |
| <a name="input_encryption_scopes"></a> [encryption\_scopes](#input\_encryption\_scopes) | Encryption scopes, keys are scope names. more info https://docs.microsoft.com/en-us/azure/storage/common/infrastructure-encryption-enable?tabs=portal | <pre>map(object({<br>    enable_infrastructure_encryption = optional(bool)<br>    source                           = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_index_path"></a> [index\_path](#input\_index\_path) | path from your repo root to index.html | `string` | `null` | no |
| <a name="input_infrastructure_encryption_enabled"></a> [infrastructure\_encryption\_enabled](#input\_infrastructure\_encryption\_enabled) | Is infrastructure encryption enabled? Changing this forces a new resource to be created. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location to MySQL server resource | `string` | n/a | yes |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | The minimum supported TLS version for the storage account. | `string` | `"TLS1_2"` | no |
| <a name="input_name"></a> [name](#input\_name) | Storage account name | `string` | `null` | no |
| <a name="input_nfsv3_enabled"></a> [nfsv3\_enabled](#input\_nfsv3\_enabled) | Is NFSv3 protocol enabled? Changing this forces a new resource to be created | `bool` | `false` | no |
| <a name="input_replication_type"></a> [replication\_type](#input\_replication\_type) | Storage account replication type - i.e. LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | name of the resource group to create the resource | `string` | n/a | yes |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | Creates a virtual network rule in the subnet\_id (values are virtual network subnet ids). | `map(string)` | `{}` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_traffic_bypass"></a> [traffic\_bypass](#input\_traffic\_bypass) | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. | `list(string)` | <pre>[<br>  "None"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_encryption_scope_ids"></a> [encryption\_scope\_ids](#output\_encryption\_scope\_ids) | encryption scope info. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Storage Account. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Storage Account. |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | The primary access key for the storage account. |
| <a name="output_primary_blob_connection_string"></a> [primary\_blob\_connection\_string](#output\_primary\_blob\_connection\_string) | The connection string associated with the primary blob location. |
| <a name="output_primary_blob_endpoint"></a> [primary\_blob\_endpoint](#output\_primary\_blob\_endpoint) | The endpoint URL for blob storage in the primary location. |
| <a name="output_primary_blob_host"></a> [primary\_blob\_host](#output\_primary\_blob\_host) | The endpoint host for blob storage in the primary location. |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | The connection string associated with the primary location. |
| <a name="output_primary_dfs_endpoint"></a> [primary\_dfs\_endpoint](#output\_primary\_dfs\_endpoint) | The endpoint URL for DFS storage in the primary location. |
| <a name="output_primary_file_endpoint"></a> [primary\_file\_endpoint](#output\_primary\_file\_endpoint) | The endpoint URL for file storage in the primary location. |
| <a name="output_primary_queue_endpoint"></a> [primary\_queue\_endpoint](#output\_primary\_queue\_endpoint) | The endpoint URL for queue storage in the primary location. |
| <a name="output_primary_table_endpoint"></a> [primary\_table\_endpoint](#output\_primary\_table\_endpoint) | The endpoint URL for table storage in the primary location. |
| <a name="output_primary_web_endpoint"></a> [primary\_web\_endpoint](#output\_primary\_web\_endpoint) | The endpoint URL for web storage in the primary location. |
| <a name="output_primary_web_host"></a> [primary\_web\_host](#output\_primary\_web\_host) | Hostname with port for web storage in the primary location. |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The Principal ID for the Service Principal associated with the Identity of this Storage Account. |
| <a name="output_sa"></a> [sa](#output\_sa) | The Storage Account object. |
| <a name="output_secondary_access_key"></a> [secondary\_access\_key](#output\_secondary\_access\_key) | The secondary access key for the storage account. |
| <a name="output_secondary_blob_connection_string"></a> [secondary\_blob\_connection\_string](#output\_secondary\_blob\_connection\_string) | The connection string associated with the secondary blob location. |
| <a name="output_secondary_blob_endpoint"></a> [secondary\_blob\_endpoint](#output\_secondary\_blob\_endpoint) | The endpoint URL for blob storage in the secondary location. |
| <a name="output_secondary_blob_host"></a> [secondary\_blob\_host](#output\_secondary\_blob\_host) | The endpoint host for blob storage in the secondary location. |
| <a name="output_secondary_connection_string"></a> [secondary\_connection\_string](#output\_secondary\_connection\_string) | The connection string associated with the secondary location. |
| <a name="output_secondary_dfs_endpoint"></a> [secondary\_dfs\_endpoint](#output\_secondary\_dfs\_endpoint) | The endpoint URL for DFS storage in the secondary location. |
| <a name="output_secondary_file_endpoint"></a> [secondary\_file\_endpoint](#output\_secondary\_file\_endpoint) | The endpoint URL for file storage in the secondary location. |
| <a name="output_secondary_queue_endpoint"></a> [secondary\_queue\_endpoint](#output\_secondary\_queue\_endpoint) | The endpoint URL for queue storage in the secondary location. |
| <a name="output_secondary_table_endpoint"></a> [secondary\_table\_endpoint](#output\_secondary\_table\_endpoint) | The endpoint URL for table storage in the secondary location. |
| <a name="output_secondary_web_endpoint"></a> [secondary\_web\_endpoint](#output\_secondary\_web\_endpoint) | The endpoint URL for web storage in the secondary location. |
| <a name="output_secondary_web_host"></a> [secondary\_web\_host](#output\_secondary\_web\_host) | Hostname with port for web storage in the secondary location. |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | The Tenant ID for the Service Principal associated with the Identity of this Storage Account. |

<!--- END_TF_DOCS --->