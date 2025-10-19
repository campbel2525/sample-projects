# ----------------------------------------------------------------
# 3. GitHub Actions用 OIDC連携ロール
#    - GitHub ActionsがAWS APIを操作（デプロイ開始）するためのロール
# ----------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.github_fingerprint]
}

resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" : var.github_subject
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_actions_apprunner_policy" {
  name        = "GitHubActions-AppRunnerECRBatchPolicy" # ポリシー名を更新
  description = "Allows GitHub Actions to manage ECR and AWS Batch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR関連
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = [
          aws_ecr_repository.user_front_ecr.arn,
          aws_ecr_repository.migration_ecr.arn,
        ]
      },
      # ECR 認証トークン取得権限
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      # AWS Batch ジョブ実行権限
      {
        Effect = "Allow",
        Action = [
          "batch:SubmitJob",
          "batch:DescribeJobs",
          "batch:DescribeJobQueues",
          "batch:DescribeJobDefinitions",
          "batch:ListJobs"
        ],
        Resource = [
          module.migration_aws_batch.job_queue_arn,
          "arn:aws:batch:${module.current_account.region_id}:${module.current_account.account_id}:job-definition/${module.migration_aws_batch.job_definition_name}",
          "arn:aws:batch:${module.current_account.region_id}:${module.current_account.account_id}:job-definition/${module.migration_aws_batch.job_definition_name}:*", # ワイルカード必須
          "arn:aws:batch:${module.current_account.region_id}:${module.current_account.account_id}:job/*",                                                              # ワイルカード必須
        ]
      },
      # CloudWatch Logsのログストリーム取得権限
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:GetLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource" : [
          "arn:aws:logs:${module.current_account.region_id}:${module.current_account.account_id}:log-group:/aws/batch/job:*" # ワイルカード必須
        ]
      },
      {
        Effect   = "Allow"
        Action   = "batch:DescribeJobs"
        Resource = "*" # ワイルカード必須
      },
      # App Runner
      {
        Effect = "Allow"
        Action = [
          "apprunner:UpdateService",
          "apprunner:DescribeService" # waitコマンドで必要
        ]
        Resource = [
          module.user_front_apprunner.apprunner_arn
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_apprunner_policy.arn
}
