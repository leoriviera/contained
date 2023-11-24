# Find public subnets in the default VPC
# data "aws_subnets" "subnets" {
#   filter {
#     name   = "vpc-id"
#     values = [var.vpc_id]
#   }

#   filter {
#     name = "map-public-ip-on-launch"
#     values = [true]
#   }
# }

# data "aws_subnet" "available" {
#   for_each = toset(data.aws_subnets.subnets.ids)
#   id       = each.key
# }

data "aws_ami_ids" "amazon_linux" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

variable "certificate_arn" {
  type     = string
  nullable = false
}

variable "hosted_zone_id" {
  type     = string
  nullable = false
}
variable "domain" {
  type     = string
  nullable = false
}

variable "instance_type" {
  type     = string
  nullable = false
}

variable "availability_zones" {
  type     = list(string)
  nullable = false
}

variable "vpc_id" {
  type = string
  nullable = false
}

variable "vpc_subnets" {
  type = list(string)
  nullable = false
}
