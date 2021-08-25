# Azure - Storage Account Module
This module will create a storage account.

<!--- BEGIN_TF_DOCS --->
Error: Unbalanced parentheses: Expected a closing parenthesis to terminate the expression. (and 1 other messages)
=======
## Requirements

| Name | Version |
|------|---------|
| azurerm | >= 2.72 |
| random | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.72 |
| random | >= 3.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_list | Map of CIDRs Storage Account access. | `map(string)` | `{}` | no |
| access\_tier | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts | `string` | `"Hot"` | no |
| account\_kind | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 | `string` | `"StorageV2"` | no |
| account\_tier | Defines the Tier to use for this storage account (Standard or Premium). | `string` | `null` | no |
| allow\_blob\_public\_access | Allow or disallow public access to all blobs or containers in the storage account. | `bool` | `false` | no |
| blob\_cors | blob service cors rules:  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule | <pre>map(object({<br>    allowed_headers    = list(string)<br>    allowed_methods    = list(string)<br>    allowed_origins    = list(string)<br>    exposed_headers    = list(string)<br>    max_age_in_seconds = number<br>  }))</pre> | `null` | no |
| blob\_delete\_retention\_days | Retention days for deleted blob. Valid value is between 1 and 365. | `number` | `7` | no |
| custom\_404\_path | path from your repo root to your custom 404 page | `string` | `null` | no |
| default\_network\_rule | Specifies the default action of allow or deny when no other network rules match | `string` | `"Deny"` | no |
| enable\_hns | Enable Hierarchical Namespace (can be used with Azure Data Lake Storage Gen 2). | `bool` | `false` | no |
| enable\_https\_traffic\_only | Forces HTTPS if enabled. | `bool` | `true` | no |
| enable\_infrastructure\_encryption | Controls if infrastructure encryption is enabled. more info https://docs.microsoft.com/en-us/azure/storage/common/infrastructure-encryption-enable?tabs=portal | `bool` | `true` | no |
| enable\_large\_file\_share | Enable Large File Share. | `bool` | `false` | no |
| enable\_static\_website | Controls if static website to be enabled on the storage account. Possible values are `true` or `false` | `bool` | `false` | no |
| index\_path | path from your repo root to index.html | `string` | `null` | no |
| location | Specifies the supported Azure location to MySQL server resource | `string` | n/a | yes |
| min\_tls\_version | The minimum supported TLS version for the storage account. | `string` | `"TLS1_2"` | no |
| name | Storage account name. | `string` | `null` | no |
| names | names to be applied to resources | `map(string)` | n/a | yes |
| nfsv3\_enabled | Is NFSv3 protocol enabled? Changing this forces a new resource to be created | `bool` | `false` | no |
| replication\_type | Storage account replication type - i.e. LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS. | `string` | n/a | yes |
| resource\_group\_name | name of the resource group to create the resource | `string` | n/a | yes |
| service\_endpoints | Creates a virtual network rule in the subnet\_id (values are virtual network subnet ids). | `map(string)` | `{}` | no |
| tags | tags to be applied to resources | `map(string)` | n/a | yes |
| traffic\_bypass | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. | `list(string)` | <pre>[<br>  "None"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| encryption\_scope\_id | n/a |
| id | The ID of the Storage Account. |
| name | The name of the Storage Account. |
| primary\_access\_key | The primary access key for the storage account. |
| primary\_blob\_endpoint | The endpoint URL for blob storage in the primary location. |
| primary\_blob\_host | The endpoint host for blob storage in the primary location. |
| primary\_connection\_string | The connection string associated with the primary location. |
| primary\_dfs\_endpoint | The endpoint URL for DFS storage in the primary location. |
| primary\_file\_endpoint | The endpoint URL for file storage in the primary location. |
| primary\_queue\_endpoint | The endpoint URL for queue storage in the primary location. |
| primary\_table\_endpoint | The endpoint URL for table storage in the primary location. |
| primary\_web\_endpoint | The endpoint URL for web storage in the primary location. |
| principal\_id | The Principal ID for the Service Principal associated with the Identity of this Storage Account. |
| sa | The Storage Account object. |
| secondary\_access\_key | The secondary access key for the storage account. |
| secondary\_blob\_endpoint | The endpoint URL for blob storage in the secondary location. |
| secondary\_blob\_host | The endpoint host for blob storage in the secondary location. |
| secondary\_connection\_string | The connection string associated with the secondary location. |
| secondary\_dfs\_endpoint | The endpoint URL for DFS storage in the secondary location. |
| secondary\_file\_endpoint | The endpoint URL for file storage in the secondary location. |
| secondary\_queue\_endpoint | The endpoint URL for queue storage in the secondary location. |
| secondary\_table\_endpoint | The endpoint URL for table storage in the secondary location. |
| secondary\_web\_endpoint | The endpoint URL for web storage in the secondary location. |
| tenant\_id | The Tenant ID for the Service Principal associated with the Identity of this Storage Account. |
<!--- END_TF_DOCS --->
