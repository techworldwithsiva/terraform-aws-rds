resource "aws_db_instance" "this" {
    allocated_storage = var.allocated_storage
    db_name = var.db_name
    engine = var.engine #mysql/postgress/mssql
    instance_class = var.instance_class
    username = var.rds_username
    vpc_security_group_ids = var.rds_security_group_ids
    db_subnet_group_name = var.db_subnet_group_name
    password = random_password.password.result
    skip_final_snapshot  = true
    tags = var.tags
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# I need to get random password and store inside secret manager so that applications can refer.

data "aws_secretsmanager_secret" "rds_password_arn" {
  arn = var.rds_password_arn
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = data.aws_secretsmanager_secret.rds_password_arn.id
  secret_string = random_password.password.result
}