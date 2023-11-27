module "infrastructure" {
  source = "./infrastructure"

  aws_region      = var.region
  domain          = var.domain
  frontend_domain = "${var.frontend_subdomain}.${var.domain}"
  instance_type   = var.instance_type
  repository      = var.repository
  server_domain   = "${var.server_subdomain}.${var.domain}"

  providers = {
    aws = aws
    aws.acm = aws.acm
  }
}

module "server" {
  source = "./server"

  availability_zones = module.infrastructure.availability_zones
  certificate_arn = module.infrastructure.certificate_arn
  domain          = "${var.server_subdomain}.${var.domain}"
  hosted_zone_id  = module.infrastructure.hosted_zone_id
  instance_type   = var.instance_type
  instance_profile_arn = module.infrastructure.instance_profile_arn
  s3_bucket_name = module.infrastructure.s3_bucket_name
  vpc_id = module.infrastructure.vpc_id
  vpc_subnets = module.infrastructure.vpc_subnets
}

