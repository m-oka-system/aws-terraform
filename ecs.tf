//
//################################
//# ECS for Web
//################################
resource "aws_ecs_cluster" "cluster" {
  name = "tf-cluster"
}
//
//resource "aws_ecs_task_definition" "taskdef" {
//  family                   = "web"
//  cpu                      = "0.25vCPU"
//  memory                   = "0.5GB"
//  network_mode             = "awsvpc"
//  requires_compatibilities = ["FARGATE"]
//  container_definitions    = file("./container_definitions.json")
//  execution_role_arn = module.ecs_task_execution_role.iam_role_arn
//}
//
//resource "aws_ecs_service" "service" {
//  name            = "tf-service"
//  cluster         = aws_ecs_cluster.cluster.arn
//  task_definition = aws_ecs_task_definition.taskdef.arn
//  desired_count   = 2
//  launch_type     = "FARGATE"
//  platform_version = "1.3.0"
//  health_check_grace_period_seconds = 60
//
//  network_configuration {
//    assign_public_ip = false
//    security_groups  = [module.nginx_sg.security_group_id]
//
//    subnets = [
////      aws_subnet.public_1a.id,
////      aws_subnet.public_1c.id
//      aws_subnet.private_1a.id,
//      aws_subnet.private_1c.id
//    ]
//  }
//
//  load_balancer {
//    target_group_arn = aws_lb_target_group.public.arn
//    container_name   = "web"
//    container_port   = 80
//  }
//
//  lifecycle {
//    ignore_changes = [task_definition]
//  }
//}
//
//module "nginx_sg" {
//  source      = "./security_group"
//  name        = "tf_nginx_sg"
//  vpc_id      = aws_vpc.vpc.id
//  port        = 80
//  cidr_blocks = [aws_vpc.vpc.cidr_block]
//}
//
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_execution" {
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}

module "ecs_task_execution_role" {
  source     = "./iam_role"
  name       = "TF_ECS_TASK_EXECUTION_IAMROLE"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}
//
//resource "aws_cloudwatch_log_group" "for_ecs" {
//  name              = "/ecs/nginx"
//  retention_in_days = 180
//}


//################################
//# ECS for Batch
//################################
//resource "aws_cloudwatch_log_group" "for_ecs_scheduled_tasks" {
//  name              = "/ecs-scheduled-tasks/batch"
//  retention_in_days = 180
//}
//
//# ECS Task definition
//resource "aws_ecs_task_definition" "batch" {
//  family                   = "batch"
//  cpu                      = "0.25vCPU"
//  memory                   = "0.5GB"
//  network_mode             = "awsvpc"
//  requires_compatibilities = ["FARGATE"]
//  container_definitions    = file("./batch_container_definitions.json")
//  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
//}
//
//# IAM Role
//module "ecs_events_role" {
//  source     = "./iam_role"
//  name       = "TF_ECS_EVENT_IAMROLE"
//  identifier = "events.amazonaws.com"
//  policy     = data.aws_iam_policy.ecs_events_role_policy.policy
//}
//
//# IAM Policy (Allow run task and pass role)
//data "aws_iam_policy" "ecs_events_role_policy" {
//  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
//}
//
//# Cloud Watch event rule
//resource "aws_cloudwatch_event_rule" "batch" {
//  name                = "batch"
//  description         = "とても重要なバッチ処理です"
//  # [*] を日および曜日フィールドの両方に使用することはできない。2分おき、時間、日*、月、曜日?、年
//  schedule_expression = "cron(*/2 * * * ? *)"
//}
//
//# Cloud Watch event target
//resource "aws_cloudwatch_event_target" "batch" {
//  arn       = aws_ecs_cluster.cluster.arn
//  rule      = aws_cloudwatch_event_rule.batch.name
//  role_arn  = module.ecs_events_role.iam_role_arn
//  target_id = "batch"
//
//  ecs_target {
//    launch_type         = "FARGATE"
//    task_count          = 1
//    platform_version    = "1.3.0"
//    task_definition_arn = aws_ecs_task_definition.batch.arn
//
//    network_configuration {
//      assign_public_ip = "false"
//      subnets          = [aws_subnet.private_1a.id]
//    }
//  }
//}
