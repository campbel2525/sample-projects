# ---------------------------------------------
# user front
# ---------------------------------------------
resource "aws_ecr_repository" "user_front_ecr" {
  name                 = "user-front-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  encryption_configuration {
    encryption_type = "AES256"
  }
}
module "user_front_apprunner" {
  source = "../../modules/create_apprunner"

  app_name = "user-front"
  subnet_ids = [
    module.private_subnet_1a.id,
    # module.private_subnet_1c.id,
  ]
  security_group_ids = [
    module.app_sg.id,
  ]
  apprunner_cpu                      = 1024
  apprunner_memory                   = 2048
  apprunner_port                     = 3000
  apprunner_auto_deployments_enabled = false # ecrにpushした場合にデプロイを走るようにするかどうか
  apprunner_image_identifier         = "${aws_ecr_repository.user_front_ecr.repository_url}:latest"

  ssm_parameter_app_env_names = [ # 実際のアプリケーションに合わせてください
    "DATABASE_URL",
    "NEXTAUTH_URL",
    "NEXTAUTH_SECRET",
  ]
}
