# ----------------------------------------------------------------
# 1. App Runner インスタンスロール
#    - 実行中のアプリケーションが他のAWSサービスにアクセスするためのロール
#    - ここではSSMパラメータストアへのアクセス権限を付与
# ----------------------------------------------------------------
resource "aws_iam_role" "apprunner_instance_role" {
  name = "${var.app_name}-apprunner-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_policy" "ssm_read_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:${module.current_account.region_id}:${module.current_account.account_id}:parameter/apprunner/${var.app_name}/env/*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "instance_role_ssm_attachment" {
  role       = aws_iam_role.apprunner_instance_role.name
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}

# ----------------------------------------------------------------
# 2. App Runner ECRアクセスロール
#    - App RunnerサービスがECRからコンテナイメージをプルするためのロール
# ----------------------------------------------------------------
resource "aws_iam_role" "apprunner_ecr_access_role" {
  name = "${var.app_name}-apprunner-ecr-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ecr_access_attachment" {
  role       = aws_iam_role.apprunner_ecr_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}
