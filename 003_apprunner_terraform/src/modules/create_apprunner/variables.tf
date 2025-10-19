variable "app_name" {
  type        = string
  description = "ケバブケースで指定してください。例: user-front"
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "apprunner_cpu" {
  type = number
}

variable "apprunner_memory" {
  type = number
}

variable "apprunner_port" {
  type = number
}

variable "apprunner_auto_deployments_enabled" {
  type        = bool
  default     = false
  description = "ECRにイメージをpushした場合に自動でデプロイを走らせるかどうか。"
}

variable "apprunner_image_identifier" {
  type        = string
  description = <<-EOF
    イメージの識別子。ECRのリポジトリURLとタグを組み合わせたもの。
    例: aws_account_id.dkr.ecr.region.amazonaws.com/repository_name:tag
    特に自動デプロイする場合は、タグを合わせることに注意です。
  EOF
}

variable "ssm_parameter_app_env_names" {
  type        = list(string)
  default     = []
  description = <<-EOF
    SSMパラメータの名前のリスト。
    例: ["DATABASE_URL", "NEXTAUTH_URL"]
  EOF
}

# variable "ecr_repository_url" {
#   type = string
# }
