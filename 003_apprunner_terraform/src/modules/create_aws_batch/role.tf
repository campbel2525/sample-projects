#-------------------------------------------------------
# IAM (Identity and Access Management)
#-------------------------------------------------------
# 1. AWS Batch サービスロール
resource "aws_iam_role" "aws_batch_role" {
  name = "aws-batch-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "batch.amazonaws.com" }
    }]
  })
}

# AWS管理ポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "aws_batch_role_policy" {
  role       = aws_iam_role.aws_batch_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}


# 【変更点】ECSクラスター削除用のカスタムポリシーを独立したリソースとして作成
resource "aws_iam_policy" "batch_ecs_policy" {
  name        = "aws-batch-policy"
  description = "Allows Batch service role to manage ECS clusters for compute environments."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:CreateCluster",
          "ecs:DeleteCluster",
          "ecs:DescribeClusters",
          "ecs:DeregisterContainerInstance",
          "ecs:ListContainerInstances",
          "ecs:ListClusters",
        ],
        Resource = "*" # ワイルカード必須
      },

    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_batch_policy_attachment" {
  role       = aws_iam_role.aws_batch_role.name
  policy_arn = aws_iam_policy.batch_ecs_policy.arn
}

# 2. ジョブ実行ロール
resource "aws_iam_role" "batch_job_execution_role" {
  name = "batch-job-execution-role-fargate"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "batch_job_execution_role_policy" {
  role       = aws_iam_role.batch_job_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# SSMパラメータを読み取るためのインラインポリシー
resource "aws_iam_role_policy" "ssm_parameter_access" {
  name = "ssm-parameter-access-policy"
  role = aws_iam_role.batch_job_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["ssm:GetParameters"],
        Resource = [
          "arn:aws:ssm:${module.current_account.region_id}:${module.current_account.account_id}:parameter/ecs/${var.app_name}/env/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["kms:Decrypt"],
        Resource = "*" # ワイルカード必須
      }
    ]
  })
}
