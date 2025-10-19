output "endpoint" {
  description = "RDSインスタンスの接続エンドポイント"
  value       = data.aws_db_instance.this.endpoint
}

# output "port" {
#   description = "RDSインスタンスのポート番号"
#   value       = data.aws_db_instance.this.port
# }

output "address" {
  description = "RDSインスタンスのDNSアドレス"
  value       = data.aws_db_instance.this.address
}

output "db_instance_arn" {
  description = "RDSインスタンスのARN"
  value       = data.aws_db_instance.this.db_instance_arn
}

# output "engine" {
#   description = "データベースエンジン"
#   value       = data.aws_db_instance.this.engine
# }

# output "engine_version" {
#   description = "データベースエンジンのバージョン"
#   value       = data.aws_db_instance.this.engine_version
# }
