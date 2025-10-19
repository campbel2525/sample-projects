resource "aws_apprunner_vpc_connector" "this" {
  count = length(var.subnet_ids) > 0 && length(var.security_group_ids) > 0 ? 1 : 0

  vpc_connector_name = "${var.app_name}-vpc-connector"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids
}

resource "aws_apprunner_service" "this" {
  service_name = "${var.app_name}-apprunner-service"

  source_configuration {
    auto_deployments_enabled = var.apprunner_auto_deployments_enabled

    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access_role.arn
    }
    image_repository {
      image_identifier      = var.apprunner_image_identifier
      image_repository_type = "ECR"

      image_configuration {
        port = var.apprunner_port

        runtime_environment_secrets = {
          for ssm_param in aws_ssm_parameter.app_env_vars :
          split("/", ssm_param.name)[4] => ssm_param.arn
        }
      }
    }
  }

  instance_configuration {
    cpu               = var.apprunner_cpu
    memory            = var.apprunner_memory
    instance_role_arn = aws_iam_role.apprunner_instance_role.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = try(aws_apprunner_vpc_connector.this[0].arn, null)
    }
  }
}
