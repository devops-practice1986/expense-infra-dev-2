module "app_alb" {
  source = "terraform-aws-modules/alb/aws"

  internal                   = true
  name                       = "${local.resource_name}-app-alb" #expense-dev-app-alb
  vpc_id                     = local.vpc_id
  subnets                    = local.private_subnet_ids
  create_security_group      = false # default sg false
  security_groups            = [data.aws_ssm_parameter.app_alb_sg_id.value]
  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    var.app_alb_tags
  )
}
# **************Listener**************
resource "aws_lb_listener" "http" {
  load_balancer_arn = module.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Application ALB</h1>"
      status_code  = "200"
    }
  }
}
# Route 53 record for App_alb
# module "records" {
#   source    = "terraform-aws-modules/route53/aws//modules/records"
#   version   = "~> 2.0" # or a specific version
#   zone_name = var.zone_name
#   records = [
#     {
#       name            = "*.app-${var.environment}" # *.app-dev.inspiredevops.online
#       type            = "CNAME"
#       ttl             = 1
#       records         = [tostring(module.app_alb.dns_name)]
#       zone_id         = [tostring(module.app_alb.zone_id)]
#       allow_overwrite = true
#     },
#   ]
# }

module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name #inspiredevops.online
  records = [
    {
      name = "*.app-${var.environment}" # *.app-dev
      type = "A"
      alias = {
        name    = module.app_alb.dns_name
        zone_id = module.app_alb.zone_id # This belongs ALB internal hosted zone, not ours
      }
      allow_overwrite = true
    }
  ]
}
