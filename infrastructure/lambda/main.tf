terraform {
  backend "s3" {
    bucket  = "terrafrom-state.adiyaolu-test.io"
    key     = "lambda.terraform_testing.tfstate"
    region  = "us-east-1"
   profile = "testinground"
  }
}

provider "aws" {
 profile = "testinground"
  region  = "us-east-1"
}


data "aws_secretsmanager_secret" "dashboard_api_limit_hook" {
  name = "${local.secrets_base}.dashboard_api_limit_hook"
}

data "aws_secretsmanager_secret_version" "dashboard_api_limit_hook" {
  secret_id = data.aws_secretsmanager_secret.dashboard_api_limit_hook.id
}

data "aws_secretsmanager_secret" "dashboard_api_url" {
  name = "${local.secrets_base}.dashboard_api_url"
}

data "aws_secretsmanager_secret_version" "dashboard_api_url" {
  secret_id = data.aws_secretsmanager_secret.dashboard_api_url.id
}
data "aws_secretsmanager_secret" "is_disabled" {
  name = "${local.secrets_base}.is_disabled"
}

data "aws_secretsmanager_secret_version" "is_disabled" {
  secret_id = data.aws_secretsmanager_secret.is_disabled.id
}
data "aws_secretsmanager_secret" "mongo_host" {
  name = "${local.secrets_base}.mongo_host"
}

data "aws_secretsmanager_secret_version" "mongo_host" {
  secret_id = data.aws_secretsmanager_secret.mongo_host.id
}

data "aws_secretsmanager_secret" "mongo_pass" {
  name = "${local.secrets_base}.mongo_pass"
}

data "aws_secretsmanager_secret_version" "mongo_pass" {
  secret_id = data.aws_secretsmanager_secret.mongo_pass.id
}
data "aws_secretsmanager_secret" "mongo_user" {
  name = "${local.secrets_base}.mongo_user"
}

data "aws_secretsmanager_secret_version" "mongo_user" {
  secret_id = data.aws_secretsmanager_secret.mongo_user.id
}

data "aws_secretsmanager_secret" "pager_duty_key" {
  name = "${local.secrets_base}.pager_duty_key"
}

data "aws_secretsmanager_secret_version" "pager_duty_key" {
  secret_id = data.aws_secretsmanager_secret.pager_duty_key.id
}

data "aws_secretsmanager_secret" "parent_aws_access_key" {
  name = "${local.secrets_base}.parent_aws_access_key"
}

data "aws_secretsmanager_secret_version" "parent_aws_access_key" {
  secret_id = data.aws_secretsmanager_secret.parent_aws_access_key.id
}

data "aws_secretsmanager_secret" "parent_aws_secret_access_key" {
  name = "${local.secrets_base}.parent_aws_secret_access_key"
}

data "aws_secretsmanager_secret_version" "parent_aws_secret_access_key" {
  secret_id = data.aws_secretsmanager_secret.parent_aws_secret_access_key.id
}

data "aws_secretsmanager_secret" "rds_db_name" {
  name = "${local.secrets_base}.rds_db_name"
}

data "aws_secretsmanager_secret_version" "rds_db_name" {
  secret_id = data.aws_secretsmanager_secret.rds_db_name.id
}
data "aws_secretsmanager_secret" "rds_hostname" {
  name = "${local.secrets_base}.rds_hostname"
}

data "aws_secretsmanager_secret_version" "rds_hostname" {
  secret_id = data.aws_secretsmanager_secret.rds_hostname.id
}

data "aws_secretsmanager_secret" "rds_password" {
  name = "${local.secrets_base}.rds_password"
}

data "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = data.aws_secretsmanager_secret.rds_password.id
}

data "aws_secretsmanager_secret" "rds_username" {
  name = "${local.secrets_base}.rds_username"
}

data "aws_secretsmanager_secret_version" "rds_username" {
  secret_id = data.aws_secretsmanager_secret.rds_username.id
}

data "aws_secretsmanager_secret" "redis_host" {
  name = "${local.secrets_base}.redis_host"
}

data "aws_secretsmanager_secret_version" "redis_host" {
  secret_id = data.aws_secretsmanager_secret.redis_host.id
}

// data "aws_secretsmanager_secret" "redis_pass" {
//   name = "${local.secrets_base}.redis_pass"
// }

// data "aws_secretsmanager_secret_version" "redis_pass" {
//   secret_id = "${data.aws_secretsmanager_secret.redis_pass.id}"
// }

data "aws_secretsmanager_secret" "redis_port" {
  name = "${local.secrets_base}.redis_port"
}

data "aws_secretsmanager_secret_version" "redis_port" {
  secret_id = data.aws_secretsmanager_secret.redis_port.id
}

data "aws_secretsmanager_secret" "stage" {
  name = "${local.secrets_base}.stage"
}

data "aws_secretsmanager_secret_version" "stage" {
  secret_id = data.aws_secretsmanager_secret.stage.id
}

data "aws_secretsmanager_secret" "tracker_api_serverless_service" {
  name = "${local.secrets_base}.tracker_api_serverless_service"
}

data "aws_secretsmanager_secret_version" "tracker_api_serverless_service" {
  secret_id = data.aws_secretsmanager_secret.tracker_api_serverless_service.id
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement : [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}



locals {
  secrets_base = "adiyaolu_testing"


  dashboard_api_limit_hook     = jsondecode(data.aws_secretsmanager_secret_version.dashboard_api_limit_hook.secret_string)
  dashboard_api_url            = jsondecode(data.aws_secretsmanager_secret_version.dashboard_api_url.secret_string)
  is_disabled                  = jsondecode(data.aws_secretsmanager_secret_version.is_disabled.secret_string)
  mongo_host                   = jsondecode(data.aws_secretsmanager_secret_version.mongo_host.secret_string)
  mongo_pass                   = jsondecode(data.aws_secretsmanager_secret_version.mongo_pass.secret_string)
  mongo_user                   = jsondecode(data.aws_secretsmanager_secret_version.mongo_user.secret_string)
  pager_duty_key               = jsondecode(data.aws_secretsmanager_secret_version.pager_duty_key.secret_string)
  parent_aws_access_key        = jsondecode(data.aws_secretsmanager_secret_version.parent_aws_access_key.secret_string)
  parent_aws_secret_access_key = jsondecode(data.aws_secretsmanager_secret_version.parent_aws_secret_access_key.secret_string)
  rds_db_name                  = jsondecode(data.aws_secretsmanager_secret_version.rds_db_name.secret_string)
  rds_hostname                 = jsondecode(data.aws_secretsmanager_secret_version.rds_hostname.secret_string)
  rds_password                 = jsondecode(data.aws_secretsmanager_secret_version.rds_password.secret_string)
  rds_username                 = jsondecode(data.aws_secretsmanager_secret_version.rds_username.secret_string)
  redis_host                   = jsondecode(data.aws_secretsmanager_secret_version.redis_host.secret_string)
  #redis_pass = jsondecode(data.aws_secretsmanager_secret_version.redis_pass.secret_string)
  redis_port                     = jsondecode(data.aws_secretsmanager_secret_version.redis_port.secret_string)
  stage                          = jsondecode(data.aws_secretsmanager_secret_version.stage.secret_string)
  tracker_api_serverless_service = jsondecode(data.aws_secretsmanager_secret_version.tracker_api_serverless_service.secret_string)
}

locals {
  base_name                      = "adiyaolu_testing"
  function_name                  = "tracker_api_testing_addToKinesis"
  handler                        = "dist/src/main.addToKinesis"
  memory_size                    = "512"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  runtime                        = "nodejs12.x"
  image_uri                      = "null"

}



resource "aws_lambda_function" "tfer__tracker_api_testing_addToKinesis" {
  environment {
    variables = {
      DASHBORD_API_LIMIT_HOOK      = local.dashboard_api_limit_hook.key
      DASHBORD_API_URL             = local.dashboard_api_url.key
      IS_DISABLED                  = local.is_disabled.key
      MONGO_HOST                   = local.mongo_host.MONGO_HOST
      MONGO_PASS                   = local.mongo_pass.MONGO_PASS
      MONGO_USER                   = local.mongo_user.MONGO_USER
      PAGER_DUTY_KEY               = local.pager_duty_key.pagerduty_key
      PARENT_AWS_ACCESS_KEY        = local.parent_aws_access_key.key
      PARENT_AWS_SECRET_ACCESS_KEY = local.parent_aws_secret_access_key.key
      RDS_DB_NAME                  = local.rds_db_name.RDS_DB_NAME
      RDS_HOSTNAME                 = local.rds_hostname.RDS_HOSTNAME
      RDS_PASSWORD                 = local.rds_password.RDS_PASSWORD
      #RDS_USERNAME                   = local.rds_username.RDS_USERNAME
      REDIS_HOST = local.redis_host.REDIS_HOST
      #REDIS_PASS                     = local.redis_pass.REDIS_PASS
      REDIS_PORT                     = local.redis_port.REDIS_PORT
      STAGE                          = local.stage.key
      TRACKER_API_SERVERLESS_SERVICE = local.tracker_api_serverless_service.key
    }
  }

  function_name                  = local.function_name
  handler                        = local.handler
  memory_size                    = local.memory_size
  package_type                   = local.package_type
  reserved_concurrent_executions = local.reserved_concurrent_executions
  role                           = aws_iam_role.iam_for_lambda.arn
  runtime                        = local.runtime
  #image_uri                      = local.image_uri
  filename         = data.archive_file.terraform_testing.output_path
 source_code_hash = data.archive_file.terraform_testing.output_base64sha256
  tags = {
    STAGE = "test"
  }

  tags_all = {
    STAGE = "test"
  }

  timeout = "20"

  tracing_config {
    mode = "PassThrough"
  }
}

data "null_data_source" "lambda_archive" {
  inputs = {
    filename = "${path.module}/main.ts"
  }
  }
data "null_data_source" "lambda_file" {
  inputs = {
    filename = "${path.module}/main.ts"
  }
}

data "archive_file" "terraform_testing" {
  type        = "zip"
  source_file = data.null_data_source.lambda_file.outputs.filename
  output_path = data.null_data_source.lambda_archive.outputs.filename
}
