output "certificate_arn" {
  value = aws_acm_certificate_validation.certificate.certificate_arn
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.hosted_zone.zone_id
}

output "iam_user_arn" {
  value = aws_iam_user.gh_action.arn
}

output "availability_zones" {
  value = local.availability_zones
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_subnets" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}
