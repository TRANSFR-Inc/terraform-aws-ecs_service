locals {
  # Nasty, disgusting hard-coded values...

  cluster_by_env = {
    sandbox = "shared-sandbox"
    dev     = "shared-dev"
    qa      = "shared-qa"
    prod    = "shared-prod"
  }

  sd_by_env = {
    sandbox = "sandbox.tx.internal"
    dev     = "dev.tx.internal"
    qa      = "qa.tx.internal"
    prod    = "prod.tx.internal"
  }

  legacy_vpc = "vpc-c86966a0"
  vpc_by_env = {
    sandbox = local.legacy_vpc
    dev     = local.legacy_vpc
    qa      = local.legacy_vpc
    prod    = local.legacy_vpc
  }

  legacy_private_subnets = [
    "subnet-0ad32443eed48d1dc",
    "subnet-0937102698f6efb58",
  ]

  subnets_by_env = {
    sandbox = local.legacy_private_subnets
    dev     = local.legacy_private_subnets
    qa      = local.legacy_private_subnets
    prod    = local.legacy_private_subnets
  }

  auto_include_sg_ids = [
    "sg-03d4f958f99d2bd0e", # Bastion/VPN
  ]
}

data "aws_service_discovery_dns_namespace" "this" {
  name = local.sd_by_env[var.env_name]
  type = "DNS_PRIVATE"
}
