<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AZURE NETWORK SECURITY GROUP


</h1>

<p align="center" style="font-size: 1.2rem;"> 
    Terraform module to create NETWORK SECURITY GROUP resource on AZURE.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v1.0.0-green" alt="Terraform">
</a>
<a href="LICENSE">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-azure-network-security-group'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AZURE+NETWORK+SECURITY+GROUP&url=https://github.com/clouddrove/terraform-azure-network-security-group'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AZURE+NETWORK+SECURITY+GROUP&url=https://github.com/clouddrove/terraform-azure-network-security-group'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards strategies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure. 

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies: 

- [Terraform 1.x.x](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-azure-network-security-group/releases).


### Simple Example
Here is an example of how you can use this module in your inventory structure:
  ```hcl
   module "network_security_group" {
    source                  = "clouddrove/subnet/network-security-group"
    version                 = "1.0.0"
    app_name                = "app"
    environment             = "test"
    resource_group_location = module.resource_group.resource_group_location
    subnet_ids              = module.subnet.default_subnet_id
    resource_group_name     = module.resource_group.resource_group_name
    inbound_rules = [
    {
      name                        = "ssh"
      priority                    = 101
      access                      = "Allow"
      protocol                    = "Tcp"
      source_address_prefix       = "10.20.0.0/32"
      #source_address_prefixes    = ["10.20.0.0/32","10.21.0.0/32"]
      source_port_range           = "*"
      destination_address_prefix  = "0.0.0.0/0"
      destination_port_range      = "22"
      description                 = "ssh allowed port"
    },
    {
      name                       = "https"
      priority                   = 102
      access                     = "Allow"
      protocol                   = "*"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "80,443"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "22"
      description                = "ssh allowed port"
      }
    ]
  }
  ```






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes (e.g. `1`). | `list(string)` | `[]` | no |
| business\_unit | Top-level division of your company that owns the subscription or workload that the resource belongs to. In smaller organizations, this tag might represent a single corporate or shared top-level organizational element. | `string` | `"Corp"` | no |
| category | The name of a Diagnostic Log Category Group for this Resource. | `string` | `null` | no |
| create | Used when creating the Resource Group. | `string` | `"30m"` | no |
| days | Number of days to create retension policies for te diagnosys setting. | `number` | `365` | no |
| delete | Used when deleting the Resource Group. | `string` | `"30m"` | no |
| enable\_diagnostic | Set to false to prevent the module from creating the diagnosys setting for the NSG Resource.. | `bool` | `false` | no |
| enabled | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| eventhub\_authorization\_rule\_id | Eventhub authorization rule id to pass it to destination details of diagnosys setting of NSG. | `string` | `null` | no |
| eventhub\_name | Eventhub Name to pass it to destination details of diagnosys setting of NSG. | `string` | `null` | no |
| extra\_tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(string)` | `{}` | no |
| inbound\_rules | List of objects that represent the configuration of each inbound rule. | `any` | `[]` | no |
| label\_order | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| log\_analytics\_destination\_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | `string` | `"AzureDiagnostics"` | no |
| log\_analytics\_workspace\_id | log analytics workspace id to pass it to destination details of diagnosys setting of NSG. | `string` | `null` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| outbound\_rules | List of objects that represent the configuration of each outbound rule. | `any` | `[]` | no |
| read | Used when retrieving the Resource Group. | `string` | `"5m"` | no |
| repository | Terraform current module repo | `string` | `""` | no |
| resource\_group\_location | The Location of the resource group where to create the network security group. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the network security group. | `string` | n/a | yes |
| retention\_policy\_enabled | Set to false to prevent the module from creating retension policy for the diagnosys setting. | `bool` | `false` | no |
| storage\_account\_id | Storage account id to pass it to destination details of diagnosys setting of NSG. | `string` | `null` | no |
| subnet\_ids | The ID of the Subnet. Changing this forces a new resource to be created. | `list(string)` | `[]` | no |
| tags | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| update | Used when updating the Resource Group. | `string` | `"30m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The network security group configuration ID. |
| name | The name of the network security group. |
| tags | The tags assigned to the resource. |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system. 

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback 
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-azure-network-security-group/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-azure-network-security-group)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=
