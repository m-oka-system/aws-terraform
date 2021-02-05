################################
# AccountID
################################
data "aws_caller_identity" "self" {}

################################
# IAMポリシー
################################
data "aws_iam_policy_document" "ec2_run_userdata" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:describe*", "ec2:CreateTags"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_policy" {
  name   = "TF_EC2_IAMPOLICY"
  policy = data.aws_iam_policy_document.ec2_run_userdata.json
}

################################
# IAMロール
################################
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "TF_EC2_IAMROLE"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  policy_arn = aws_iam_policy.ec2_policy.arn
  role       = aws_iam_role.ec2_role.name
}

################################
# モジュール利用
################################
module "describe_instances_for_ec2" {
  source     = "./iam_role"
  name       = "TF_EC2_RUN_USERDATA"
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.ec2_run_userdata.json
}
