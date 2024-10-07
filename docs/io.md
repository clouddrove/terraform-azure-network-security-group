## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create | Used when creating the Resource Group. | `string` | `"30m"` | no |
| delete | Used when deleting the Resource Group. | `string` | `"30m"` | no |
| enable\_diagnostic | Set to false to prevent the module from creating the diagnosys setting for the NSG Resource.. | `bool` | `false` | no |
| enable\_flow\_logs | Flag to be set true when network security group flow logging feature is to be enabled. | `bool` | `false` | no |
| enable\_traffic\_analytics | Boolean flag to enable/disable traffic analytics. | `bool` | `false` | no |
| enabled | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| eventhub\_authorization\_rule\_id | Eventhub authorization rule id to pass it to destination details of diagnosys setting of NSG. | `string` | `null` | no |
| eventhub\_name | Eventhub Name to pass it to destination details of diagnosys setting of NSG. | `string` | `null` | no |
| extra\_tags | Variable to pass extra tags. | `map(string)` | `null` | no |
| flow\_log\_retention\_policy\_days | The number of days to retain flow log records. | `number` | `100` | no |
| flow\_log\_retention\_policy\_enabled | Boolean flag to enable/disable retention. | `bool` | `false` | no |
| flow\_log\_storage\_account\_id | The id of storage account in which flow logs will be received. Note: Currently, only standard-tier storage accounts are supported. | `string` | `null` | no |
| flow\_log\_version | The version (revision) of the flow log. Possible values are 1 and 2. | `number` | `1` | no |
| inbound\_rules | List of objects that represent the configuration of each inbound rule. | `any` | `[]` | no |
| label\_order | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| log\_analytics\_destination\_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | `string` | `"AzureDiagnostics"` | no |
| log\_analytics\_workspace\_id | log analytics workspace id to pass it to destination details of diagnosys setting of NSG. | `string` | `null` | no |
| log\_analytics\_workspace\_resource\_id | The resource ID of the attached log analytics workspace. | `string` | `null` | no |
| logs | List of log categories. Defaults to all available. | `list(map(string))` | `[]` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| network\_watcher\_name | The name of the Network Watcher. Changing this forces a new resource to be created. | `string` | `null` | no |
| outbound\_rules | List of objects that represent the configuration of each outbound rule. | `any` | `[]` | no |
| read | Used when retrieving the Resource Group. | `string` | `"5m"` | no |
| repository | Terraform current module repo | `string` | `""` | no |
| resource\_group\_location | The Location of the resource group where to create the network security group. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the network security group. | `string` | n/a | yes |
| subnet\_ids | The ID of the Subnet. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| update | Used when updating the Resource Group. | `string` | `"30m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The network security group configuration ID. |
| name | The name of the network security group. |
| network\_watcher\_name | The name of the Network Watcher. Changing this forces a new resource to be created. |
| storage\_account\_id | The ID of the Storage Account where flow logs are stored. |
| subnet\_id | The ID of the Subnet. Changing this forces a new resource to be created. |
| tags | The tags assigned to the resource. |
