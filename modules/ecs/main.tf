##  elasteic conatiner service 







locals {
    
    
  xray_definition = <<EOF
{
    "name": "xray-daemon",
    "image": "${var.xray_docker_image}",
    "cpu": 32,
    "memoryReservation": 256,
    "environment": [
        { "name" : "AWS_REGION", "value" : "${var.region}" },
        { "name" : "AWS_ACCESS_KEY_ID", "value" : "${var.aws_access_key}" },       
        { "name" : "AWS_SECRET_ACCESS_KEY", "value" : "${var.aws_secret_access_key}" }
    ],
    "portMappings" : [
        {
            "hostPort": 2000,
            "containerPort": 2000,
            "protocol": "udp"
        }
     ],
     "logConfiguration": {
       "logDriver": "awslogs",
       "options": {
         "awslogs-region": "${var.region}",
         "awslogs-group": "${aws_cloudwatch_log_group.ecs.name}",
         "awslogs-stream-prefix": "ecs-xray"
       }
     }
  },
EOF  

  sidecar_definitions = var.xray_docker_image == "" ? "" : local.xray_definition
  
  lowered_cpu = var.task_cpu - 32
  base_cpu = var.xray_docker_image == "" ? var.task_cpu : local.lowered_cpu
  
    
  env_keys = keys(var.container_environment)
  env_map = [
    for key in local.env_keys :  {
      name : key,
      value : var.container_environment[key]
    }
  ]
  env_str = jsonencode(local.env_map) 
  
  
  secrets_keys = keys(var.container_secrets)
  secrets_map = [
    for key in local.secrets_keys :  {
      name : key,
      valueFrom : var.container_secrets[key]
    }
  ]
  secret_env_str = jsonencode(local.secrets_map) 
  
 
  base_definitions = <<EOF
{
    "name": "${var.container_name}",
    "image": "${var.docker_image}",
    "essential": true,
    "environment" :  ${local.env_str}, 
    "secrets" :  ${local.secret_env_str},     
    "cpu": ${local.base_cpu},
    "memory": ${var.task_memory}, 
    "portMappings": [
         {
           "hostPort": ${var.container_port},
           "containerPort": ${var.container_port},
           "protocol": "tcp"
         }
       ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${var.region}",
        "awslogs-group": "${aws_cloudwatch_log_group.ecs.name}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
EOF

  container_definitions = join(" ", ["[",local.sidecar_definitions,local.base_definitions, "]"])


  
}


resource "aws_cloudwatch_log_group" "ecs" {
  name              =  "${var.name_prefix}-ecs-service"
  retention_in_days = 1
}


resource "aws_ecs_task_definition" "ecs" {
  family = var.task_family
  requires_compatibilities = ["FARGATE"]

  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions    = local.container_definitions
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn 
  
  
}


resource "aws_ecs_service" "ecs" {
  name            = var.name_prefix
  cluster         = aws_ecs_cluster.ecs.arn
  task_definition = aws_ecs_task_definition.ecs.arn

  desired_count = var.min_capacity

  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  
  
  force_new_deployment = true
  launch_type = "FARGATE"
  propagate_tags = "SERVICE"
  wait_for_steady_state = false
  

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  } 
  
  network_configuration {
	security_groups = var.security_groups
	subnets         = var.subnets
	assign_public_ip = var.assign_public_ip
  }
  
  lifecycle {
      ignore_changes = [desired_count]
  }
  
}


resource "aws_ecs_cluster" "ecs" {

  name =  "${var.name_prefix}-ecs-cluster"

  capacity_providers = ["FARGATE"]

  setting {
    name  = "containerInsights"
    value = "enabled" 
  }
  
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base = 0
    weight = 1
  }
  
  
}


data "aws_iam_policy_document" "task-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name_prefix}-ecs_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.task-assume-role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_secretsmanager_policy" {
  role = aws_iam_role.ecs_task_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
      Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
      ]
      Effect   = "Allow"
      Resource = var.secret_arns
      },
    ]
  })

}  


resource "aws_iam_role" "autoscaling" {
  name = "${var.name_prefix}-ecs-appautoscaling-role"

   assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect   = "Allow"
        Principal = {
          "Service": "ecs.application-autoscaling.amazonaws.com"
        }
      },
    ]
  })

  
}

resource "aws_iam_role_policy" "autoscaling" {
  name   = "${var.name_prefix}-ecs-appautoscaling-policy"
  role   = aws_iam_role.autoscaling.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
      Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DeleteAlarms"
      ]
      Effect   = "Allow"
      Resource =  [ "*" ]
      },
    ]
  })

}

resource "aws_appautoscaling_target" "ecs" {

  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.ecs.name}"
  role_arn           = aws_iam_role.autoscaling.arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.ecs]
}

resource "aws_appautoscaling_policy" "ecs" {

  name               = "${var.name_prefix}-ecs-autoscaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = var.appautoscaling_target_cpu
    scale_in_cooldown  = var.appautoscaling_scale_in_cooldown
    scale_out_cooldown = var.appautoscaling_scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }

  depends_on = [aws_appautoscaling_target.ecs]
}






