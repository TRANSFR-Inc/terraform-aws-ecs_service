resource "aws_ecs_service" "this" {
  name        = var.app_name
  cluster     = local.cluster_by_env[var.env_name]
  launch_type = "FARGATE"

  task_definition = "dummy"
  desired_count   = 1

  enable_ecs_managed_tags = true

  network_configuration {
    subnets         = local.subnets_by_env[var.env_name]
    security_groups = [aws_security_group.this.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.this.arn
  }

  dynamic "load_balancer" {
    for_each = var.target_group_arns
    content {
      target_group_arn = load_balancer.value
      container_name   = var.main_container_name
      container_port   = var.main_container_port
    }
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}

resource "aws_security_group" "this" {
  name   = "${var.app_name}-${var.env_name}"
  vpc_id = local.vpc_by_env[var.env_name]

  ingress {
    from_port       = var.main_container_port
    to_port         = var.main_container_port
    protocol        = "tcp"
    security_groups = setunion(local.auto_include_sg_ids, var.ingress_sg_ids)
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/app/${var.app_name}/${var.env_name}"
  retention_in_days = 7
}

resource "aws_secretsmanager_secret" "this" {
  count = var.create_secret ? 1 : 0
  name  = "/app/${var.app_name}/${var.env_name}"
}

resource "aws_service_discovery_service" "this" {
  name = var.app_name

  dns_config {
    namespace_id = data.aws_service_discovery_dns_namespace.this.id

    dns_records {
      type = "A"
      ttl  = 10
    }
  }
}
