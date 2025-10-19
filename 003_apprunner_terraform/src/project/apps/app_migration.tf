# ---------------------------------------------
# migration
# ---------------------------------------------
resource "aws_ecr_repository" "migration_ecr" {
  name                 = "migration-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  encryption_configuration {
    encryption_type = "AES256"
  }
}

module "migration_aws_batch" {
  source = "../../modules/create_aws_batch"

  app_name = "migration"
  security_group_ids = [
    module.migration_sg.id
  ]
  subnets = [
    module.private_subnet_1a.id
  ]
  aws_batch_max_vcpus   = 16
  job_definition_vcpus  = 1.0
  job_definition_memory = 2048
  job_definition_image  = "${aws_ecr_repository.migration_ecr.repository_url}:latest"
  ssm_parameter_app_env_names = [ # 実際のアプリケーションに合わせてください
    "DATABASE_URL",
  ]
}
