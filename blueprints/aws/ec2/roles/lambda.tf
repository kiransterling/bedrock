data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ec2_cycle" {
  name               = "bedrock-ec2-cycle-role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ec2_fullaccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = "${aws_iam_role.ec2_cycle.id}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/bedrock-cloudwatch-logs"
  role       = "${aws_iam_role.ec2_cycle.id}"
}

resource "aws_iam_role" "ec2_cleanup" {
  name               = "bedrock-ec2-cleanup-role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ec2_fullaccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = "${aws_iam_role.ec2_cleanup.id}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/bedrock-cloudwatch-logs"
  role       = "${aws_iam_role.ec2_cleanup.id}"
}
