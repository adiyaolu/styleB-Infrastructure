resource "aws_config_config_rule" "config_rule_with_frequency" {

  for_each = var.config_rules_with_execution_frequency

  name                        = each.key
  description                 = each.value.description
  maximum_execution_frequency = each.value.maximum_execution_frequency

  source {
    owner             = each.value.owner
    source_identifier = each.value.source_identifier
  }

  depends_on = [aws_config_configuration_recorder.adiyaolu-config]
}

resource "aws_config_config_rule" "config_rule_without_frequency" {

  for_each = var.config_rules_without_execution_frequency

  name        = each.key
  description = each.value.description

  source {
    owner             = each.value.owner
    source_identifier = each.value.source_identifier
  }

  depends_on = [aws_config_configuration_recorder.adiyaolu-config]
}