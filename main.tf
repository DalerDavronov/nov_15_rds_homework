terraform {
  cloud {
    organization = "Ziyotek_Terraform_Class_Summer_Cloud"

    workspaces {
      name = "nov_15_rds_homework"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "demodb"

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "demodb"
  username = "user"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["sg-03338ba344b0750c7"]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

   # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = ["subnet-0b917dcda2c28933c", "subnet-0b56b2fe6fc65ae02"]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

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