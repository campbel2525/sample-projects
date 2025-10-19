
variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "security_group_ids" {
  description = "The name of the application"
  type        = list(string)
}

variable "subnets" {
  description = "The name of the application"
  type        = list(string)
}

variable "aws_batch_max_vcpus" {
  description = "The name of the application"
  type        = string
}

variable "job_definition_vcpus" {
  description = "The name of the application"
  type        = number
}

variable "job_definition_memory" {
  description = "The name of the application"
  type        = number
}

variable "job_definition_image" {
  description = "The name of the application"
  type        = string
}

variable "ssm_parameter_app_env_names" {
  type = list(string)
}
