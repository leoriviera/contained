module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "141.42.0.0/16"
  networks = [for az in local.availability_zones : { name = az, new_bits = 4 }]
}
