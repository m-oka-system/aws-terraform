//################################
//# RDS
//################################
//resource "aws_db_parameter_group" "mysql" {
//  name = "${var.db_identifier}-parameter-group"
//  family = "mysql8.0"
//
//  parameter {
//    name = "character_set_database"
//    value = "utf8mb4"
//  }
//
//  parameter {
//    name = "character_set_server"
//    value = "utf8mb4"
//  }
//}
//
//resource "aws_db_option_group" "mysql" {
//  name = "${var.db_identifier}-option-group"
//  engine_name = "mysql"
//  major_engine_version = "8.0"
//}
//
//resource "aws_db_subnet_group" "subnet_group" {
//  name = "tf-db-subnet"
//  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]
//}
//
//resource "aws_db_instance" "mysql" {
//  identifier = var.db_identifier
//  instance_class = "db.t3.micro"
//  availability_zone = "ap-northeast-1a"
//  multi_az = false
//  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
//  parameter_group_name = aws_db_parameter_group.mysql.name
//  option_group_name = aws_db_option_group.mysql.name
//  vpc_security_group_ids = [module.mysql_sg.security_group_id]
//  allocated_storage = 20
//  max_allocated_storage = 100
//  storage_type = "gp2"
//  storage_encrypted = true
//  kms_key_id = aws_kms_key.customer_key.arn
//  engine = "mysql"
//  engine_version = "8.0.20"
//  license_model = "general-public-license"
//  name = "MyDatabase"
//  port = 3306
//  username = "root"
//  password = "password"
//  publicly_accessible = false
//  copy_tags_to_snapshot = true
//  backup_retention_period = 2
//  backup_window = "19:00-20:00"
//  maintenance_window = "Sat:20:00-Sat:21:00"
//  monitoring_interval = 60
//  monitoring_role_arn = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/rds-monitoring-role"
//  enabled_cloudwatch_logs_exports = ["error","general","slowquery"]
//  performance_insights_enabled = false
//  auto_minor_version_upgrade = false
//  deletion_protection = false
//  skip_final_snapshot = true
//  apply_immediately = false
//
//  tags = {
//    Name = var.db_identifier
//    env = "dev"
//  }
//
//  lifecycle {
//    ignore_changes = [password]
//  }
//}
//
//module "mysql_sg" {
//  source      = "./security_group"
//  name        = "tf_mysql_sg"
//  vpc_id      = aws_vpc.vpc.id
//  port        = 3306
//  cidr_blocks = [aws_vpc.vpc.cidr_block]
//}
//
//resource "aws_db_event_subscription" "mysql" {
//  name      = "${var.db_identifier}-alert"
//  sns_topic = aws_sns_topic.rds.arn
//
//  source_type = "db-instance"
//  source_ids  = [aws_db_instance.mysql.id]
//  depends_on = [aws_db_instance.mysql]
//
//  event_categories = [
//    "failover",
//    "notification",
//    "maintenance",
//    "failure"
//  ]
//}
//
//resource "aws_sns_topic" "rds" {
//  name = "rds-events"
//}
