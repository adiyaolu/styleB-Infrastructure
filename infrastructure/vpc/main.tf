##  vpc
## NOTE: This should not be run directly. Instead, run staging/infra or prod/infra




// Network
module "vpc" {
  source               = "../../modules/vpc"
  region               = var.region
  cidr                 = var.vpc_cidr
  name_prefix          = var.base_name
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  extra_tags           = var.extra_tags
}


module "public-subnets" {
  source      = "../../modules/subnets"
  vpc_id      = module.vpc.vpc_id
  name_prefix = "${var.base_name}-public"
  cidr_blocks = var.public_subnet_cidrs
  extra_tags= merge(
    {
      "Type" = "Public"
    },
    var.extra_tags,
  )  

}


module "internet-gateway" {
  source            = "../../modules/internet-gateway"
  vpc_id            = module.vpc.vpc_id
  name_prefix       = "${var.base_name}-public"
  extra_tags        = var.extra_tags
  public_subnet_ids = module.public-subnets.ids
}








