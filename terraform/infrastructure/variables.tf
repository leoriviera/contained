data "aws_availability_zones" "all" {}

data "aws_cloudfront_cache_policy" "caching_policy" {
  name = "Managed-CachingOptimized"
}

data "aws_ec2_instance_type_offerings" "available" {
  for_each = toset(data.aws_availability_zones.all.names)

  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }


  filter {
    name   = "location"
    values = [each.key]
  }

  location_type = "availability-zone"
}

data "github_repository" "repo" {
  full_name = var.repository
}

data "aws_route53_zone" "hosted_zone" {
  name         = "${var.domain}."
  private_zone = false
}

# Finding AZs which support particular instances
# https://stackoverflow.com/a/63728735
locals {
 availability_zones = keys({
    for az, details in data.aws_ec2_instance_type_offerings.available :
    az => details.instance_types if length(details.instance_types) != 0
  })
}

variable "domain" {
  type     = string
  nullable = false
}

variable "repository" {
  type     = string
  nullable = false
}

variable "frontend_domain" {
  type     = string
  nullable = false
}

variable "server_domain" {
  type     = string
  nullable = false
}

variable "aws_region" {
  type     = string
  nullable = false
}

variable "instance_type" {
  type = string
  nullable = false
}
