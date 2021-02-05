//################################
//# EC2
//################################
//# IAM Role
//module "ec2_for_ssm_role" {
//  source     = "./iam_role"
//  name       = "TF_EC2_SSM_IAMROLE"
//  identifier = "ec2.amazonaws.com"
//  policy     = data.aws_iam_policy_document.ec2_for_ssm_policy.json
//}
//
//# IAM Policy
//data "aws_iam_policy_document" "ec2_for_ssm_policy" {
//  source_json = data.aws_iam_policy.ec2_for_ssm.policy
//
//  statement {
//    effect    = "Allow"
//    resources = ["*"]
//
//    actions = [
//      "s3:PutObject",
//      "logs:PutLogEvents",
//      "logs:CreateLogStream",
//      "ecr:GetAuthorizationToken",
//      "ecr:BatchCheckLayerAvailability",
//      "ecr:GetDownloadUrlForLayer",
//      "ecr:BatchGetImage",
//      "ssm:GetParameter",
//      "ssm:GetParameters",
//      "ssm:GetParametersByPath",
//      "kms:Decrypt",
//    ]
//  }
//}
//
//data "aws_iam_policy" "ec2_for_ssm" {
//  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
//}
//
//# Instance profile
//resource "aws_iam_instance_profile" "ec2_for_ssm" {
//  name = "ec2-for-ssm"
//  role = module.ec2_for_ssm_role.iam_role_name
//}
//
//# EC2 instance
//data "aws_ssm_parameter" "amzn2_latest_ami" {
//  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
//}
//
//resource "aws_instance" "amzn2" {
//  ami                  = data.aws_ssm_parameter.amzn2_latest_ami.value
//  instance_type        = "t2.micro"
//  iam_instance_profile = aws_iam_instance_profile.ec2_for_ssm.name
//  subnet_id            = aws_subnet.private_1a.id
//  user_data            = file("./userdata/amzn2.sh")
//
//  tags = {
//    Name = "AmazonLinux2"
//    env  = "dev"
//  }
//}
//
//# S3 for ssm log
//resource "aws_s3_bucket" "ssm" {
//  bucket = "tf-session-manager-logs"
//  force_destroy = true
//
//  lifecycle_rule {
//    enabled = true
//
//    expiration {
//      days = 180
//    }
//  }
//}
//
//# CloudWatch Logs for ssm log
//resource "aws_cloudwatch_log_group" "ssm" {
//  name              = "/session_manager"
//  retention_in_days = 180
//}
//
//# SSM Document
//resource "aws_ssm_document" "ssm" {
//  name            = "SSM-SessionManagerRunShell"
//  document_type   = "Session"
//  document_format = "JSON"
//  content         = <<EOF
//  {
//    "schemaVersion": "1.0",
//    "description": "Document to hold regional settings for Session Manager",
//    "sessionType": "Standard_Stream",
//    "inputs": {
//      "s3BucketName": "${aws_s3_bucket.ssm.id}",
//      "cloudWatchLogGroupName": "${aws_cloudwatch_log_group.ssm.name}"
//    }
//  }
//EOF
//}
