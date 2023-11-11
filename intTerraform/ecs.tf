provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
}

# Cluster
resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "D8-cluster"
  tags = {
    Name = "D8-ecs"
  }
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "/ecs/D8-logs"
  tags = {
    Application = "D8-app"
  }
}

# Task Definition FRONTEND
resource "aws_ecs_task_definition" "aws-ecs-taskfront" {
  family = "D8-task"
  container_definitions = <<EOF
  [
  {
      "name": "D8FRONT-container",
      "image": "kevingonzalez7997/frontv1",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/D8-logs",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 3000
        }
      ]
    }
  ]
  EOF
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::347142919260:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::347142919260:role/ecsTaskExecutionRole"
}

# ECS Service FRONTEND
resource "aws_ecs_service" "aws-ecs-servicefront" {
  name                 = "aws-ecs-servicefront"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-taskfront.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2
  force_new_deployment = true
  network_configuration {
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]
    assign_public_ip = true
    security_groups  = [aws_security_group.ingress_app.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.bank-appTARGET.arn
    container_name   = "D8FRONT-container"
    container_port   = 3000
  }
}

# Task Definition BACKEND
resource "aws_ecs_task_definition" "aws-ecs-taskback" {
  family = "D8-task"
  container_definitions = <<EOF
  [
  {
      "name": "D8BACK-container",
      "image": "kevingonzalez7997/backv1",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/D8-logs",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 8000
        }
      ]
    }
  ]
  EOF
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::347142919260:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::347142919260:role/ecsTaskExecutionRole"
}

# ECS Service BACKEND
resource "aws_ecs_service" "aws-ecs-serviceback" {
  name                 = "D8BACK-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-taskback.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true
  network_configuration {
    subnets = [
      aws_subnet.private_a.id
      # aws_subnet.private_b.id
    ]
    assign_public_ip = false
    security_groups  = [aws_security_group.backend_app.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.bank-appTARGET.arn
    container_name   = "D8BACK-container"
    container_port   = 8000
  }
}