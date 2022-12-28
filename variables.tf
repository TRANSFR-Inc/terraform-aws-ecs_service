variable "app_name" {}
variable "env_name" {}

variable "main_container_name" {
  description = "Name of main container as seen in task definition"
  default     = "main"
}

variable "main_container_port" {
  description = "Port of main container as seen in task definition"
  default     = 8080
  type        = number
}

variable "create_secret" {
  description = "Whether or not to create a Secrets Manager Secret for app"
  type        = bool
}

variable "target_group_arns" {
  description = "List of target group ARNs so to expose app to load balancer"
  type        = list(string)
}

variable "ingress_sg_ids" {
  description = "List of security group IDs to allow traffic from; include SG ID from load balancer if you plan to use one"
  type        = list(string)
}
