output "ecs_service" {
  value = {
    arn  = aws_ecs_service.this.id
    id   = aws_ecs_service.this.id
    name = aws_ecs_service.this.name
  }
}

output "security_group" {
  value = {
    arn  = aws_security_group.this.arn
    id   = aws_security_group.this.id
    name = try(aws_security_group.this.tags_all["name"], aws_security_group.this.tags_all["Name"], null)
  }
}

output "cloud_watch_log_group" {
  value = {
    arn  = aws_security_group.this.arn
    id   = aws_security_group.this.name
    name = aws_security_group.this.name
  }
}

output "secret" {
  value = {
    arn  = try(aws_secretsmanager_secret.this[0].arn, null)
    id   = try(aws_secretsmanager_secret.this[0].id, null)
    name = try(aws_secretsmanager_secret.this[0].id, null)
  }
}

locals {
  sd_id   = aws_service_discovery_service.this.id
  sd_ns   = data.aws_service_discovery_dns_namespace.this.id
  sd_fqdn = "${local.sd_id}.${local.sd_ns}"
  sd_ep   = "${local.sd_fqdn}:${var.main_container_port}"
}

output "service_discovery" {
  value = {
    id        = local.sd_id
    namespace = local.sd_ns
    fqdn      = local.sd_fqdn
    endpoint  = local.sd_ep
  }
}
