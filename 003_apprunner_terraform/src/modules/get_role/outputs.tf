output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the role."
  value       = data.aws_iam_role.role.arn
}

output "id" {
  description = "The name of the role."
  value       = data.aws_iam_role.role.id
}

output "unique_id" {
  description = "The stable and unique string identifying the role."
  value       = data.aws_iam_role.role.unique_id
}
