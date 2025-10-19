#-------------------------------------------------------
# AWS Batch (Fargate)
#-------------------------------------------------------
# コンピューティング環境
resource "aws_batch_compute_environment" "batch_ce_fargate" {
  name         = "${var.app_name}-compute-env"
  type         = "MANAGED"
  service_role = aws_iam_role.aws_batch_role.arn

  compute_resources {
    type               = "FARGATE"
    max_vcpus          = var.aws_batch_max_vcpus
    security_group_ids = var.security_group_ids
    subnets            = var.subnets
  }

  # サービスロールにカスタムポリシーがアタッチされるのを待つための依存関係
  depends_on = [
    aws_iam_role_policy_attachment.aws_batch_policy_attachment
  ]
}

# ジョブキュー
resource "aws_batch_job_queue" "batch_job_queue" {
  name     = "${var.app_name}-job-queue"
  priority = 1
  state    = "ENABLED"

  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.batch_ce_fargate.arn
  }
}

# ジョブ定義
resource "aws_batch_job_definition" "batch_job_definition" {
  name                  = "${var.app_name}-job-definition"
  type                  = "container"
  platform_capabilities = ["FARGATE"]

  container_properties = jsonencode({
    image            = var.job_definition_image
    executionRoleArn = aws_iam_role.batch_job_execution_role.arn
    secrets = [
      for env_name in var.ssm_parameter_app_env_names : {
        name      = env_name
        valueFrom = aws_ssm_parameter.app_env_vars[env_name].arn
      }
    ]
    resourceRequirements = [
      {
        type  = "VCPU"
        value = tostring(var.job_definition_vcpus)
      },
      {
        type  = "MEMORY"
        value = tostring(var.job_definition_memory)
      }
    ]
    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }
  })
}
