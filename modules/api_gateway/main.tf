

resource "aws_api_gateway_rest_api" "adiyaolu" {
  name = var.base_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_resource" "adiyaolu" {
  rest_api_id = aws_api_gateway_rest_api.adiyaolu.id
  parent_id   = aws_api_gateway_rest_api.adiyaolu.root_resource_id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "adiyaolu" {
  rest_api_id   = aws_api_gateway_rest_api.adiyaolu.id
  resource_id   = aws_api_gateway_resource.adiyaolu.id
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.adiyaolu.id
  resource_id             = aws_api_gateway_resource.adiyaolu.id
  http_method             = aws_api_gateway_method.adiyaolu.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://adiyaolu.io/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "adiyaolu" {
  rest_api_id = aws_api_gateway_rest_api.adiyaolu.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.adiyaolu.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "adiyaolu" {
  deployment_id = aws_api_gateway_deployment.adiyaolu.id
  rest_api_id   = aws_api_gateway_rest_api.adiyaolu.id
  stage_name    = var.base_name
}

resource "aws_cloudwatch_log_group" "adiyaolu" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.adiyaolu.id}/${var.base_name}"
  retention_in_days = 7
  # ... potentially other configuration ...
}