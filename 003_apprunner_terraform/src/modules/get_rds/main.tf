data "aws_db_instance" "this" {
  db_instance_identifier = var.db_instance_identifier
}
