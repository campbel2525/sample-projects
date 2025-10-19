Not yet verified.

Please remove this message after verification is complete.

Sample:

```
module "user_front_apprunner" {
  source = "../../modules/create_apprunner"

  app_name                           = "user-front"
  apprunner_cpu                      = 256
  apprunner_memory                   = 512
  apprunner_port                     = 3000
  apprunner_auto_deployments_enabled = false # whether to trigger deploys on ECR push
  apprunner_image_identifier         = "${aws_ecr_repository.user_front_ecr.repository_url}:latest"
  subnet_ids = [
    module.private_subnet_1a.id,
    # module.private_subnet_1c.id,
  ]
  security_group_ids = [
    module.app_sg.id,
  ]
  ssm_parameter_app_env_names = [ # adjust to your application
    "DATABASE_URL",
    "NEXTAUTH_URL",
    "NEXTAUTH_SECRET",
  ]
}
```

