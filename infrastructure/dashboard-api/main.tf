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

data "aws_secretsmanager_secret" "analytics-ranges-password" {
  name = "${var.secrets_base}.analytics-ranges-password"
}

data "aws_secretsmanager_secret_version" "analytics-ranges-password" {
  secret_id = data.aws_secretsmanager_secret.analytics-ranges-password.id
}

data "aws_secretsmanager_secret" "aws-access-key" {
  name = "${var.secrets_base}.aws-access-key"
}

data "aws_secretsmanager_secret_version" "aws-access-key" {
  secret_id = data.aws_secretsmanager_secret.aws-access-key.id
}

data "aws_secretsmanager_secret" "clickfunnels" {
  name = "${var.secrets_base}.clickfunnels"
}

data "aws_secretsmanager_secret_version" "clickfunnels" {
  secret_id = data.aws_secretsmanager_secret.clickfunnels.id
}

data "aws_secretsmanager_secret" "amplitude" {
  name = "${var.secrets_base}.amplitude"
}

data "aws_secretsmanager_secret_version" "amplitude" {
  secret_id = data.aws_secretsmanager_secret.amplitude.id
}

data "aws_secretsmanager_secret" "adiyaolu-aws-log" {
  name = "${var.secrets_base}.adiyaolu-aws-log"
}

data "aws_secretsmanager_secret_version" "adiyaolu-aws-log" {
  secret_id = data.aws_secretsmanager_secret.adiyaolu-aws-log.id
}

data "aws_secretsmanager_secret" "sku" {
  name = "${var.secrets_base}.sku"
}

data "aws_secretsmanager_secret_version" "sku" {
  secret_id = data.aws_secretsmanager_secret.sku.id
}

data "aws_secretsmanager_secret" "hubspot" {
  name = "${var.secrets_base}.hubspot"
}

data "aws_secretsmanager_secret_version" "hubspot" {
  secret_id = data.aws_secretsmanager_secret.hubspot.id
}

data "aws_secretsmanager_secret" "recaptcha" {
  name = "${var.secrets_base}.recaptcha"
}

data "aws_secretsmanager_secret_version" "recaptcha" {
  secret_id = data.aws_secretsmanager_secret.recaptcha.id
}

data "aws_secretsmanager_secret" "recurly" {
  name = "${var.secrets_base}.recurly"
}

data "aws_secretsmanager_secret_version" "recurly" {
  secret_id = data.aws_secretsmanager_secret.recurly.id
}

data "aws_secretsmanager_secret" "s3" {
  name = "${var.secrets_base}.s3"
}

data "aws_secretsmanager_secret_version" "s3" {
  secret_id = data.aws_secretsmanager_secret.s3.id
}

data "aws_secretsmanager_secret" "screenshots-cloud" {
  name = "${var.secrets_base}.screenshots-cloud"
}

data "aws_secretsmanager_secret_version" "screenshots-cloud" {
  secret_id = data.aws_secretsmanager_secret.screenshots-cloud.id
}

data "aws_secretsmanager_secret" "segment-write" {
  name = "${var.secrets_base}.segment-write"
}

data "aws_secretsmanager_secret_version" "segment-write" {
  secret_id = data.aws_secretsmanager_secret.segment-write.id
}

data "aws_secretsmanager_secret" "sendgrid" {
  name = "${var.secrets_base}.sendgrid"
}

data "aws_secretsmanager_secret_version" "sendgrid" {
  secret_id = data.aws_secretsmanager_secret.sendgrid.id
}

data "aws_secretsmanager_secret" "slack" {
  name = "${var.secrets_base}.slack"
}

data "aws_secretsmanager_secret_version" "slack" {
  secret_id = data.aws_secretsmanager_secret.slack.id
}

data "aws_secretsmanager_secret" "stripe" {
  name = "${var.secrets_base}.stripe"
}

data "aws_secretsmanager_secret_version" "stripe" {
  secret_id = data.aws_secretsmanager_secret.stripe.id
}

data "aws_secretsmanager_secret" "tapfiliate" {
  name = "${var.secrets_base}.tapfiliate"
}

data "aws_secretsmanager_secret_version" "tapfiliate" {
  secret_id = data.aws_secretsmanager_secret.tapfiliate.id
}

data "aws_secretsmanager_secret" "thinkific" {
  name = "${var.secrets_base}.thinkific"
}

data "aws_secretsmanager_secret_version" "thinkific" {
  secret_id = data.aws_secretsmanager_secret.thinkific.id
}

data "aws_secretsmanager_secret" "tracking-aws" {
  name = "${var.secrets_base}.tracking-aws"
}

data "aws_secretsmanager_secret_version" "tracking-aws" {
  secret_id = data.aws_secretsmanager_secret.tracking-aws.id
}

data "aws_secretsmanager_secret" "woo-commerce" {
  name = "${var.secrets_base}.woo-commerce"
}

data "aws_secretsmanager_secret_version" "woo-commerce" {
  secret_id = data.aws_secretsmanager_secret.woo-commerce.id
}

data "aws_secretsmanager_secret" "zerobounce" {
  name = "${var.secrets_base}.zerobounce"
}

data "aws_secretsmanager_secret_version" "zerobounce" {
  secret_id = data.aws_secretsmanager_secret.zerobounce.id
}

data "aws_secretsmanager_secret" "postgresql-mirror" {
  name = "${var.secrets_base}.postgresql-mirror"
}

data "aws_secretsmanager_secret_version" "postgresql-mirror" {
  secret_id = data.aws_secretsmanager_secret.postgresql-mirror.id
}

data "aws_secretsmanager_secret" "rds" {
  name = "${var.secrets_base}.rds"
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = data.aws_secretsmanager_secret.rds.id
}

locals {

  aws_api_keys = jsondecode(data.aws_secretsmanager_secret_version.aws-api-keys.secret_string)
  postgresql = jsondecode(data.aws_secretsmanager_secret_version.postgresql.secret_string)
  postgresql_mirror = jsondecode(data.aws_secretsmanager_secret_version.postgresql-mirror.secret_string)
  clickfunnels = jsondecode(data.aws_secretsmanager_secret_version.clickfunnels.secret_string)
  recurly = jsondecode(data.aws_secretsmanager_secret_version.recurly.secret_string)
  s3 = jsondecode(data.aws_secretsmanager_secret_version.s3.secret_string)
  thinkific = jsondecode(data.aws_secretsmanager_secret_version.thinkific.secret_string)
  woo_commerce = jsondecode(data.aws_secretsmanager_secret_version.woo-commerce.secret_string)
  rds = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)
  redis = jsondecode(data.aws_secretsmanager_secret_version.redis.secret_string)

  environment_variables = {
    ADMIN_EMAIL="alekcei.glazunov@gmail.com"
    PORT="3002"
    APP_URL="http://localhost:4200"

    AWS_REGION="us-west-2"
    AWS_S3_REGION="us-west-2"

    CLICKFUNNELS_USER=local.clickfunnels.username

    DISABLE_API="false"

    DRIP_API_KEY="43edd32ec4e0564cb2e80fb27bff58f4"

    RECURLY_ENVIRONMENT=local.recurly.environment
    RECURLY_SUBDOMAIN=local.recurly.subdomain

    RDS_HOSTNAME=local.rds.hostname
    RDS_PORT=local.rds.port
    RDS_DB_NAME=local.rds.db-name
    RDS_USERNAME=local.rds.username

    REDIS_HOST=local.redis.host
    REDIS_PORT=local.redis.port

    S3_FUNNELS_BUCKET=local.s3.bucket
    S3_PROJECT_LOGOS_BUCKET=local.s3.project-logos-bucket

    THINKIFIC_SUBDOMAIN = local.thinkific.subdomain

    WOOCOMMERCE_USERNAME = local.woo_commerce.username

    DASHBOARD_RDS_DB_NAME = local.postgresql.db-name
    DASHBOARD_RDS_HOSTNAME = local.postgresql.hostname
    DASHBOARD_RDS_PORT = local.postgresql.port
    DASHBOARD_RDS_USERNAME = local.postgresql.username

    DASHBOARD_MIRROR_RDS_DB_NAME=local.postgresql_mirror.db-name
    DASHBOARD_MIRROR_RDS_HOSTNAME=local.postgresql_mirror.hostname
    DASHBOARD_MIRROR_RDS_PORT=local.postgresql_mirror.port
    DASHBOARD_MIRROR_RDS_USERNAME=local.postgresql_mirror.username

    DASHBOARD_KNEX_CONNECTION_POOL_MAX="10"
    DASHBOARD_KNEX_CONNECTION_POOL_MIN="6"

    NODE_ENV=var.node_env
  }
  
  environment_secrets = {
    AMPLITUDE_API_KEY="${data.aws_secretsmanager_secret_version.amplitude.arn}:key::"
    ANALYTICS_RANGES_PASSWORD="${data.aws_secretsmanager_secret_version.analytics-ranges-password.arn}:password::"
    AWS_ACCESS_KEY="${data.aws_secretsmanager_secret_version.aws-access-key.arn}:key::"
    CLICKFUNNELS_PASSWORD="${data.aws_secretsmanager_secret_version.clickfunnels.arn}:password::"
    adiyaolu_AWS_LOG_KEY="${data.aws_secretsmanager_secret_version.adiyaolu-aws-log.arn}:key::"
    adiyaolu_AWS_LOG_SECRET="${data.aws_secretsmanager_secret_version.adiyaolu-aws-log.arn}:secret::"
    FUNNEL_IGNITE_SKU="${data.aws_secretsmanager_secret_version.sku.arn}:funnel-ignite-sku::"
    BUMP_SKU="${data.aws_secretsmanager_secret_version.sku.arn}:bump-sku::"
    ICONS_SKU="${data.aws_secretsmanager_secret_version.sku.arn}:icons-sku::"
    PLUS_SKU="${data.aws_secretsmanager_secret_version.sku.arn}:plus-sku::"
    PREMIUM_FULL_PRICE_SKU="${data.aws_secretsmanager_secret_version.sku.arn}:premium-full-price-sku::"
    PREMIUM_PROMO_SKU="${data.aws_secretsmanager_secret_version.sku.arn}:premium-promo-sku::"
    PREMIUM_SKU="${data.aws_secretsmanager_secret_version.sku.arn}:premium-sku::"
    VAULT_PROMO_SKU="${data.aws_secretsmanager_secret_version.sku.arn}:vault-promo-sku::"
    VAULT_SKU="${data.aws_secretsmanager_secret_version.sku.arn}:vault-sku::"
    HUBSPOT_API_KEY="${data.aws_secretsmanager_secret_version.hubspot.arn}:key::"
    RECAPTCHA_SECRET="${data.aws_secretsmanager_secret_version.recaptcha.arn}:secret::"
    RECURLY_API_KEY="${data.aws_secretsmanager_secret_version.recurly.arn}:key::"
    RECURLY_WEBHOOK_KEY="${data.aws_secretsmanager_secret_version.recurly.arn}:webhook-key::"
    S3_ACCESS_KEY="${data.aws_secretsmanager_secret_version.s3.arn}:key::"
    S3_SECRET_KEY="${data.aws_secretsmanager_secret_version.s3.arn}:secret::"
    SCREENSHOTS_CLOUD_KEY="${data.aws_secretsmanager_secret_version.screenshots-cloud.arn}:key::"
    SCREENSHOTS_CLOUD_SECRET="${data.aws_secretsmanager_secret_version.screenshots-cloud.arn}:secret::"
    SEGMENT_WRITE_KEY="${data.aws_secretsmanager_secret_version.segment-write.arn}:key::"
    SENDGRID_API_KEY="${data.aws_secretsmanager_secret_version.sendgrid.arn}:key::"
    SLACK_WEBHOOK_URL="${data.aws_secretsmanager_secret_version.slack.arn}:webhook-url::"
    STRIPE_KEY="${data.aws_secretsmanager_secret_version.stripe.arn}:key::"
    TAPFILIATE_KEY="${data.aws_secretsmanager_secret_version.tapfiliate.arn}:key::"
    THINKIFIC_API_KEY="${data.aws_secretsmanager_secret_version.thinkific.arn}:key::"
    TRACKING_AWS_ACCESS_KEY_ID="${data.aws_secretsmanager_secret_version.tracking-aws.arn}:key::"
    TRACKING_AWS_SECRET_ACCESS_KEY="${data.aws_secretsmanager_secret_version.tracking-aws.arn}:secret::"
    WOOCOMMERCE_PASSWORD="${data.aws_secretsmanager_secret_version.woo-commerce.arn}:password::"
    WOO_COMMERCE_WEBHOOK_KEY="${data.aws_secretsmanager_secret_version.woo-commerce.arn}:webhook-key::"
    WOO_COMMERCE_WEBHOOK_SECRET="${data.aws_secretsmanager_secret_version.woo-commerce.arn}:webhook-secret::"
    ZEROBOUNCE_API_KEY="${data.aws_secretsmanager_secret_version.zerobounce.arn}:key::"
    NPM_TOKEN="${data.aws_secretsmanager_secret_version.npm.arn}:token::"
    API_LOG_DNA_KEY = "${data.aws_secretsmanager_secret_version.logdna.arn}:key::"
    DASHBOARD_RDS_PASSWORD="${data.aws_secretsmanager_secret.postgresql.arn}:password::"
    DASHBOARD_MIRROR_RDS_PASSWORD="${data.aws_secretsmanager_secret.postgresql-mirror.arn}:password::"
    REDIS_PASS="${data.aws_secretsmanager_secret.redis.arn}:password::"
    TOKEN_SECRET="${data.aws_secretsmanager_secret.token.arn}:token::"
    RDS_PASSWORD="${data.aws_secretsmanager_secret.rds.arn}:password::"
  }
    
  secret_arns = [
    data.aws_secretsmanager_secret_version.amplitude.arn,
    data.aws_secretsmanager_secret_version.analytics-ranges-password.arn,
    data.aws_secretsmanager_secret_version.aws-access-key.arn,
    data.aws_secretsmanager_secret_version.clickfunnels.arn,
    data.aws_secretsmanager_secret_version.adiyaolu-aws-log.arn,
    data.aws_secretsmanager_secret_version.sku.arn,
    data.aws_secretsmanager_secret_version.hubspot.arn,
    data.aws_secretsmanager_secret_version.recaptcha.arn,
    data.aws_secretsmanager_secret_version.recurly.arn,
    data.aws_secretsmanager_secret_version.s3.arn,
    data.aws_secretsmanager_secret_version.screenshots-cloud.arn,
    data.aws_secretsmanager_secret_version.segment-write.arn,
    data.aws_secretsmanager_secret_version.sendgrid.arn,
    data.aws_secretsmanager_secret_version.slack.arn,
    data.aws_secretsmanager_secret_version.stripe.arn,
    data.aws_secretsmanager_secret_version.tapfiliate.arn,
    data.aws_secretsmanager_secret_version.thinkific.arn,
    data.aws_secretsmanager_secret_version.tracking-aws.arn,
    data.aws_secretsmanager_secret_version.woo-commerce.arn,
    data.aws_secretsmanager_secret_version.zerobounce.arn,
    data.aws_secretsmanager_secret.postgresql-mirror.arn,
    data.aws_secretsmanager_secret_version.npm.arn ,
    data.aws_secretsmanager_secret_version.logdna.arn,
    data.aws_secretsmanager_secret_version.postgresql.arn,
    data.aws_secretsmanager_secret_version.redis.arn,
    data.aws_secretsmanager_secret_version.token.arn,
    data.aws_secretsmanager_secret_version.rds.arn
  ]
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