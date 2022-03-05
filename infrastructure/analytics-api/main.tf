## docker-api
## NOTE: This should not be run directly. 

data "aws_vpc" "vpc" {
   tags = merge(
    {
      "Name" = var.vpc_name
    },
    var.extra_tags,
  )
}

data "aws_subnet_ids" "vpc_public" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Type"
    values = ["Public"] 
  }
}

data "aws_security_group" "lb" {
  name = "${var.lb_name}-sg"
}

data "aws_secretsmanager_secret" "aws-api-keys" {
  name = "${var.secrets_base}.aws-api-keys"
}

data "aws_secretsmanager_secret_version" "aws-api-keys" {
  secret_id = data.aws_secretsmanager_secret.aws-api-keys.id
}

data "aws_secretsmanager_secret" "logdna" {
  name = "${var.secrets_base}.logdna"
}

data "aws_secretsmanager_secret_version" "logdna" {
  secret_id = data.aws_secretsmanager_secret.logdna.id
}

data "aws_secretsmanager_secret" "mongodb" {
  name = "${var.secrets_base}.mongodb"
}

data "aws_secretsmanager_secret_version" "mongodb" {
  secret_id = data.aws_secretsmanager_secret.mongodb.id
}

data "aws_secretsmanager_secret" "redshift" {
  name = "${var.secrets_base}.redshift"
}

data "aws_secretsmanager_secret_version" "redshift" {
  secret_id = data.aws_secretsmanager_secret.redshift.id
}

data "aws_secretsmanager_secret" "postgresql" {
  name = "${var.secrets_base}.postgresql"
}

data "aws_secretsmanager_secret_version" "postgresql" {
  secret_id = data.aws_secretsmanager_secret.postgresql.id
}

data "aws_secretsmanager_secret" "redis" {
  name = "${var.secrets_base}.redis"
}

data "aws_secretsmanager_secret_version" "redis" {
  secret_id = data.aws_secretsmanager_secret.redis.id
}

data "aws_secretsmanager_secret" "token" {
  name = "${var.secrets_base}.token"
}

data "aws_secretsmanager_secret_version" "token" {
  secret_id = data.aws_secretsmanager_secret.token.id
}

data "aws_secretsmanager_secret" "npm" {
  name = "${var.secrets_base}.npm"
}

data "aws_secretsmanager_secret_version" "npm" {
  secret_id = data.aws_secretsmanager_secret.npm.id
}

data "aws_secretsmanager_secret" "rds" {
  name = "${var.secrets_base}.rds"
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = data.aws_secretsmanager_secret.rds.id
}

locals {

  aws_api_keys = jsondecode(data.aws_secretsmanager_secret_version.aws-api-keys.secret_string)
  mongodb = jsondecode(data.aws_secretsmanager_secret_version.mongodb.secret_string)
  redshift = jsondecode(data.aws_secretsmanager_secret_version.redshift.secret_string)
  postgresql = jsondecode(data.aws_secretsmanager_secret_version.postgresql.secret_string)
  rds = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)
  redis = jsondecode(data.aws_secretsmanager_secret_version.redis.secret_string)

  environment_variables = {
    MONGO_HOST = local.mongodb.host
    MONGO_USER = local.mongodb.username

    DASHBOARD_RDS_DB_NAME = local.postgresql.db-name
    DASHBOARD_RDS_HOSTNAME = local.postgresql.hostname
    DASHBOARD_RDS_PORT = local.postgresql.port
    DASHBOARD_RDS_USERNAME = local.postgresql.username

    REDSHIFT_HOSTNAMES = local.redshift.hostnames
    REDSHIFT_PORT = local.redshift.port
    REDSHIFT_USERNAME = local.redshift.username
    REDSHIFT_DB_NAME = local.redshift.db-name

    RDS_HOSTNAME=local.rds.hostname
    RDS_PORT=local.rds.port
    RDS_DB_NAME=local.rds.db-name
    RDS_USERNAME=local.rds.username

    REDIS_HOST=local.redis.host
    REDIS_PORT=local.redis.port

    TRACKING_DB_TYPE="mongo"
    WINSTON_FORCE_LOGS="true"
    NODE_ENV=var.node_env

    adiyaolu_QUERY_TIMEOUT_IN_MS="60000"
    KNEX_ANALYTICS_CONNECTION_POOL_MAX="16"
    KNEX_ANALYTICS_CONNECTION_POOL_MIN="0"
    KNEX_CONNECTION_POOL_MAX="12"
    KNEX_CONNECTION_POOL_MIN="0"
    ANALYTICS_TIMEOUT="1200000"
  }
  
  environment_secrets = {
    NPM_TOKEN="${data.aws_secretsmanager_secret_version.npm.arn}:token::"
    API_LOG_DNA_KEY = "${data.aws_secretsmanager_secret_version.logdna.arn}:key::"
    DASHBOARD_RDS_PASSWORD="${data.aws_secretsmanager_secret.postgresql.arn}:password::"
    MONGO_PASS="${data.aws_secretsmanager_secret.mongodb.arn}:password::"
    REDSHIFT_PASSWORD="${data.aws_secretsmanager_secret.redshift.arn}:password::"
    REDIS_PASS="${data.aws_secretsmanager_secret.redis.arn}:password::"
    TOKEN_SECRET="${data.aws_secretsmanager_secret.token.arn}:token::"
    RDS_PASSWORD="${data.aws_secretsmanager_secret.rds.arn}:password::"
  }
    
  secret_arns = [ data.aws_secretsmanager_secret_version.npm.arn ,
                  data.aws_secretsmanager_secret_version.logdna.arn,
                  data.aws_secretsmanager_secret_version.postgresql.arn,
                  data.aws_secretsmanager_secret_version.mongodb.arn,
                  data.aws_secretsmanager_secret_version.redshift.arn,
                  data.aws_secretsmanager_secret_version.redis.arn,
                  data.aws_secretsmanager_secret_version.token.arn,
                  data.aws_secretsmanager_secret_version.rds.arn ]
}

module "main-s3-logs" {
  source  = "../../modules/s3-logs"
  bucket_name = "${var.base_name}-logs"
}

module "main-ecs" {
  source  = "../../modules/ecs"
  
  name_prefix = "${var.base_name}-api"
  base_description = var.base_description
  region = var.region  
  extra_tags = var.extra_tags
 
  security_groups = [ data.aws_security_group.lb.id  ]
  
  subnets = data.aws_subnet_ids.vpc_public.ids
  assign_public_ip = true
  
  task_family = var.task_family
  task_cpu = var.task_cpu
  task_memory = var.task_memory
  
  min_capacity = 1
  max_capacity = 4
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 50
  
  docker_image = var.docker_image
  container_name = var.container_name
  container_port = var.container_port
  container_environment = merge(local.environment_variables, var.container_environment)
  container_secrets = local.environment_secrets
  secret_arns = local.secret_arns
  
  xray_docker_image = var.xray_docker_image
  aws_access_key = local.aws_api_keys.key_id
  aws_secret_access_key = local.aws_api_keys.secret
  
  lb_target_group_arn = module.lb-target.lb_target_group_arn
 
}

module "lb-target" {
  source  = "../../modules/load-balancer-target"
  name_prefix = "${var.base_name_short}-api"
  
  vpc_id  = data.aws_vpc.vpc.id  
  subnet_ids = data.aws_subnet_ids.vpc_public.ids
  lb_name = var.lb_name
  
  profile = var.profile
  dns_profile = var.dns_profile  
  zone = var.site_zone  
  domain = var.api_domain
  target_group_port = var.container_port
  rule_priority = var.rule_priority
  warmup_time = var.warmup_time
  
  health_check_enabled = var.health_check_enabled
  health_check_interval = var.health_check_interval
  health_check_timeout = var.health_check_timeout
  health_check_path = var.health_check_path
  health_check_healthy_threshold = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
}