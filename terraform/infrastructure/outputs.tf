output "availability_zones" {
  value = local.availability_zones
}

output "certificate_arn" {
  value = aws_acm_certificate_validation.certificate.certificate_arn
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.hosted_zone.zone_id
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.instance_profile.arn
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_subnets" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}
