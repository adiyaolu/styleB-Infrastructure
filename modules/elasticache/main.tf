resource "aws_elasticache_parameter_group" "adiyaolu" {
  name   = "${var.name}-ecache-param"
  family = var.elasticache_family
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_subnet" "adiyaolu_public_subnet" {
  id = var.data_public_subnet

}

data "aws_subnet" "adiyaolu_private_subnet" {
  id = var.data_private_subnet_1

}

resource "aws_elasticache_subnet_group" "adiyaolu" {
  name       = "adiyaolu-cache-subnet"
  subnet_ids = [data.aws_subnet.adiyaolu_public_subnet.id, data.aws_subnet.adiyaolu_public_subnet.id]
}



resource "aws_elasticache_cluster" "main" {
  cluster_id        = "${var.name}-ecache"
  engine            = var.elasticache_engine
  node_type         = var.elasticache_node_type
  num_cache_nodes   = var.elasticache_nodes_num
  port              = var.elasticache_port
  subnet_group_name = aws_elasticache_subnet_group.adiyaolu.id
  engine_version = var.engine_version
  parameter_group_name = aws_elasticache_parameter_group.adiyaolu.id
  lifecycle {
    create_before_destroy = true
  }
}

