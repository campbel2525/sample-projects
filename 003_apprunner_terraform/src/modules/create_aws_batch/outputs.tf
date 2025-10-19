output "job_queue_name" {
  value = aws_batch_job_queue.batch_job_queue.name
}

output "job_queue_arn" {
  value = aws_batch_job_queue.batch_job_queue.arn
}

output "job_definition_name" {
  value = aws_batch_job_definition.batch_job_definition.name
}

output "job_definition_arn" {
  value = aws_batch_job_definition.batch_job_definition.arn
}
