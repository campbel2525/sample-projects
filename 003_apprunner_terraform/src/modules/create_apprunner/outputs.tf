output "apprunner_arn" {
  value = aws_apprunner_service.this.arn
}

output "apprunner_service_url" {
  value = aws_apprunner_service.this.service_url
}
