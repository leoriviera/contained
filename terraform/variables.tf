variable "region" {
  type     = string
  nullable = false
  default  = "us-east-1"
}

variable "domain" {
  type     = string
  nullable = false
  default  = "amipeak.co.uk"
}

variable "frontend_subdomain" {
  type     = string
  nullable = false
  default  = "sh"
}

variable "server_subdomain" {
  type     = string
  nullable = false
  default  = "sh-srv"
}

variable "instance_type" {
  type     = string
  nullable = false
  default  = "t3.micro"
}

variable "repository" {
  type     = string
  nullable = false
  default  = "leoriviera/contained"
}
