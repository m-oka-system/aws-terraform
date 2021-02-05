//################################
//# Route 53
//################################
//resource "aws_route53_zone" "public" {
//  name = "m-oka-system.com"
//
//}
//
//output "public_zone_id" {
//  value = aws_route53_zone.public.zone_id
//}
//
//resource "aws_route53_record" "alb" {
//  name    = aws_route53_zone.public.name
//  zone_id = aws_route53_zone.public.zone_id
//  type    = "A"
//
//  alias {
//    name                   = aws_lb.alb.dns_name
//    zone_id                = aws_lb.alb.zone_id
//    evaluate_target_health = true
//  }
//}
//
//output "domain_name" {
//  value = aws_route53_record.alb.name
//}
//
//################################
//# ACM
//################################
//resource "aws_acm_certificate" "public" {
//  domain_name               = aws_route53_zone.public.name
//  subject_alternative_names = ["*.${aws_route53_zone.public.name}"]
//  validation_method         = "DNS"
//
//  lifecycle {
//    create_before_destroy = true
//  }
//
//  tags = {
//    Name = aws_route53_zone.public.name
//  }
//}
//
//resource "aws_route53_record" "public_dns_verify" {
//  name    = aws_acm_certificate.public.domain_validation_options[0].resource_record_name
//  type    = aws_acm_certificate.public.domain_validation_options[0].resource_record_type
//  records = [aws_acm_certificate.public.domain_validation_options[0].resource_record_value]
//  zone_id = aws_route53_zone.public.id
//  ttl     = 60
//}
//
//resource "aws_acm_certificate_validation" "public" {
//  certificate_arn         = aws_acm_certificate.public.arn
//  validation_record_fqdns = [aws_route53_record.public_dns_verify.fqdn]
//}
