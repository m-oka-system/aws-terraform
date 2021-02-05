//################################
//# ALB
//################################
//resource "aws_lb" "alb" {
//  name                       = "tf-web-alb"
//  load_balancer_type         = "application"
//  internal                   = false
//  idle_timeout               = 60
//  enable_deletion_protection = false
//
//  subnets = [
//    aws_subnet.public_1a.id,
//    aws_subnet.public_1c.id
//  ]
//
//  access_logs {
//    bucket  = aws_s3_bucket.alb_log.id
//    enabled = true
//  }
//
//  security_groups = [
//    module.http.security_group_id,
//    module.https.security_group_id,
//    module.http_redirect.security_group_id,
//  ]
//
//}
//
////resource "aws_lb_listener" "http" {
////  load_balancer_arn = aws_lb.alb.arn
////  port              = "80"
////  protocol          = "HTTP"
////
////  default_action {
////    type = "fixed-response" # forwad / fixed-response / redirect
////
////    fixed_response {
////      content_type = "text/plain"
////      message_body = "これは[HTTP]です"
////      status_code  = "200"
////    }
////  }
////}
//
//resource "aws_lb_listener" "https" {
//  load_balancer_arn = aws_lb.alb.arn
//  port              = "443"
//  protocol          = "HTTPS"
//  certificate_arn   = aws_acm_certificate.public.arn
//  ssl_policy        = "ELBSecurityPolicy-2016-08"
//
//  default_action {
//    type             = "forward"
//    target_group_arn = aws_lb_target_group.public.arn
//
//    //    type = "fixed-response"
//    //    fixed_response {
//    //      content_type = "text/plain"
//    //      message_body = "これは[HTTPS]です"
//    //      status_code  = "200"
//    //    }
//  }
//}
//
//resource "aws_lb_listener" "http_to_https" {
//  load_balancer_arn = aws_lb.alb.arn
//  port              = "80"
//  protocol          = "HTTP"
//
//  default_action {
//    type = "redirect"
//
//    redirect {
//      port        = "443"
//      protocol    = "HTTPS"
//      status_code = "HTTP_301"
//    }
//  }
//}
//
//resource "aws_lb_target_group" "public" {
//  name                 = "tf-web-alb-tg"
//  target_type          = "ip"
//  vpc_id               = aws_vpc.vpc.id
//  port                 = 80
//  protocol             = "HTTP"
//  deregistration_delay = 300
//
//  health_check {
//    path                = "/"
//    healthy_threshold   = 5
//    unhealthy_threshold = 2
//    timeout             = 5
//    interval            = 30
//    matcher             = 200
//    port                = "traffic-port"
//    protocol            = "HTTP"
//  }
//
//  depends_on = [aws_lb.alb]
//}
//
//resource "aws_lb_listener_rule" "public" {
//  listener_arn = aws_lb_listener.https.arn
//  priority     = 100
//
//  action {
//    type             = "forward"
//    target_group_arn = aws_lb_target_group.public.arn
//  }
//
//  condition {
//    path_pattern {
//      values = ["/*"]
//    }
//  }
//}
//
//output "alb_dns_name" {
//  value = aws_lb.alb.dns_name
//}
