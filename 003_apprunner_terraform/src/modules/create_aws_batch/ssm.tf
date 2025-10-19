#-------------------------------------------------------
# SSM (Systems Manager) Parameter Store
#-------------------------------------------------------
resource "aws_ssm_parameter" "app_env_vars" {
  for_each = toset(var.ssm_parameter_app_env_names)

  name  = "/ecs/${var.app_name}/env/${each.value}"
  type  = "SecureString"
  value = "default-value"

  lifecycle {
    ignore_changes = [value]
  }
}
