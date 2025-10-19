output "repository_url" {
  description = "The URL of the ECR repository"
  value       = data.aws_ecr_repository.this.repository_url
}

output "arn" {
  description = "The ARN of the ECR repository"
  value       = data.aws_ecr_repository.this.arn
}

output "registry_id" {
  description = "The AWS account ID of the registry"
  value       = data.aws_ecr_repository.this.registry_id
}

output "name" {
  description = "The AWS account ID of the registry"
  value       = data.aws_ecr_repository.this.name
}
