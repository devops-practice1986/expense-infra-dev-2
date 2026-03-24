module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.resource_name

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name                     = "transactions"
  username                    = var.user_name
  manage_master_user_password = false
  password_wo                 = var.password
  password_wo_version         = 1
  port                        = "3306"

  vpc_security_group_ids = [local.mysql_sg_id]
  skip_final_snapshot    = true # if we give false , automatically attach to vpc, so con't delete,so yes


  tags = merge(
    var.common_tags,
    var.rds_tags
  )

  # DB subnet group
  db_subnet_group_name = local.database_subnet_group_name

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"


  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  # bellow re default values
  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

#for i in $(ls -dr */) ; do echo ${i%/}; cd ${i%/}; terraform destroy -auto-approve ; cd .. ; done

#for i in $(ls -d */) ; do echo ${i%/}; cd ${i%/}; terraform apply -auto-approve ; cd .. ; done

module "route53_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0" # or a specific version

  zone_name = var.zone_name
  records = [
    {
      name    = "mysql-${var.environment}"
      type    = "CNAME"
      ttl     = 1
      records = [tostring(module.db.db_instance_address)]
      allow_overwrite = true
    },
        
  ]
  
}