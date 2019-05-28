/**
 * # AWS Solr host configuration
 *
 * Provision an EC2 instance with Apache Solr installed.
 */
data "aws_caller_identity" "current" {}

data "aws_vpc" "tenant" {
  default = "${var.vpc_default}"
  tags    = "${var.vpc_tags}"
}

//data "aws_subnet_ids" "default" {
//  vpc_id = "${data.aws_vpc.default.id}"
//  tags {
//    Name = "${var.subnet}"
//  }
//}

data "aws_ami" "solr_image" {
  filter {
    name   = "name"
    values = ["${var.image_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  most_recent = true
  owners      = ["${replace(var.image_owner, "/\\A\\z/", data.aws_caller_identity.current.account_id)}"]
}

data "aws_iam_role" "solr_cloudformation" {
  name = "bedrock-apachesolr-cloudformation"
}

data "template_file" "userdata" {
  template = "${file(format("%s/%s.yml", var.userdata_path, var.image_os))}"

  vars {
    AuthorizedUserName = "${var.solr_user}"

    //    AuthorizedUserSSHKey = "${replace(var.ssh_key, "/\\A\\z/", file(var.ssh_key_file))}"
    AuthorizedUserSSHKey = "${replace(var.ssh_key, "/\\A\\z/", "")}"
    SolrHostname         = "${var.environment}-apachesolr"
    SolrVersion          = "${var.solr_version}"
  }
}

resource "aws_cloudformation_stack" "solr" {
  name         = "${var.environment}-apachesolr"
  capabilities = ["CAPABILITY_IAM"]
  iam_role_arn = "${data.aws_iam_role.solr_cloudformation.arn}"

  parameters {
    Environment = "${var.environment}"

    //    KeyPair = ""
    VpcId        = "${data.aws_vpc.tenant.id}"
    VpcCidrBlock = "${data.aws_vpc.tenant.cidr_block}"

    //    SubnetId = "${data.aws_subnet_ids.default.ids[0]}"
    ImageId        = "${data.aws_ami.solr_image.image_id}"
    InstanceType   = "${var.instance_type}"
    UserData       = "${base64encode(data.template_file.userdata.rendered)}"
    HostedZoneName = "${var.hosted_zone}."
    RouteName      = "${var.environment}-apachesolr.${var.hosted_zone}"
  }

  template_body = "${file(format("%s/apachesolr.yml", var.cloudformation_path))}"
}
