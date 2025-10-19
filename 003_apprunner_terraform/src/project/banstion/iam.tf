data "aws_iam_policy" "ec2_for_ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ec2_for_ssm" {
  source_policy_documents = [data.aws_iam_policy.ec2_for_ssm.policy]

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObject",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      # "ssm:GetParameter",
      # "ssm:GetParameters",
      # "ssm:GetParametersByPath",
      "kms:Decrypt",
      # "rds:*",
      "ssm:StartSession",
      "ssm:*",
    ]
  }
}


resource "aws_iam_role" "ec2_for_ssm_role" {
  name               = "ec2-for-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_for_ssm_document_policy.json
}
data "aws_iam_policy_document" "ec2_for_ssm_document_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_policy" "ec2_for_ssm_iam_policy" {
  name   = "ec2-for-ssm-policy"
  policy = data.aws_iam_policy_document.ec2_for_ssm.json
}
resource "aws_iam_role_policy_attachment" "ec2_for_ssm_policy_attachment" {
  role       = aws_iam_role.ec2_for_ssm_role.name
  policy_arn = aws_iam_policy.ec2_for_ssm_iam_policy.arn
}
