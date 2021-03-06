# AWS Bastion role configuration

Purpose: Provision IAM roles in AWS.

Rationale: Bedrock blueprints use IAM roles to restrict the privileges of the provisioner.

This script will create roles that has the following privileges:

* Access for managing Bastion hosts specific to this blueprint
* Access to read/write Terraform state associated with the account

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| assume\_role\_account | AWS account ID for the role to assume into | string | - | yes |
| region | AWS default region | string | - | yes |

