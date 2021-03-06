# Digital Ocean Reverse Proxy host configuration

Provision a droplet with NGINX and letsencrypt installed.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| amplify\_key | API key for nginx amplify | string | - | yes |
| do\_region | Digital Ocean region | string | - | yes |
| do\_token | Digital Ocean API token | string | - | yes |
| enabled | Start/stop the reverseproxy host | string | - | yes |
| environment | Environment identifier for the reverseproxy host | string | - | yes |
| image\_os | The operating system installed on the selected AMI. Valid values are:<br><br>  * ubuntu  = Ubuntu | string | `ubuntu` | no |
| papertrail\_host | Target URL for Papertrail logs | string | - | yes |
| papertrail\_port | Target port for Papertrail logs | string | - | yes |
| reverseproxy\_image | Digital Ocean image for reverseproxy droplet | string | `ubuntu-18-04-x64` | no |
| reverseproxy\_user | Username for reverseproxy SSH user | string | - | yes |
| ssh\_key | Identifier of public key file for SSH access to droplets | string | - | yes |
| upstream\_ports | A list of ports to route upstream traffic | list | `<list>` | no |
| userdata\_path | The root path to userdata templates | string | `userdata` | no |

## Outputs

| Name | Description |
|------|-------------|
| do\_region | Digital Ocean region |
| do\_token | Digital Ocean API token |
| enabled | Start/stop the reverseproxy host |
| floating\_ip | Floating IP address for reverseproxy droplet |
| reverseproxy\_ip | IP address for reverseproxy droplet |
| reverseproxy\_ip\_private | Private IP address for reverseproxy droplet |
| ssh\_key | Location of public key file for SSH access to droplets |

