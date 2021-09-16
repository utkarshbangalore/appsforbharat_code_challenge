resource "aws_ecs_cluster" "test-ecs-cluster" {
  name = "ecs-cluster-for-test"
}

resource "aws_ecs_service" "test-ecs-service-two" {
  name            = "test-app"
  cluster         = aws_ecs_cluster.test-ecs-cluster.id
  task_definition = aws_ecs_task_definition.test-ecs-task-definition.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = ["subnet-05t93f90b22ba76qx"]
    assign_public_ip = true
  }
  desired_count = 1
}

resource "aws_ecs_task_definition" "test-ecs-task-definition" {
  family                   = "ecs-task-definition-test"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
  container_definitions    = <<EOF
[
  {
    "name": "test-container",
    "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/test-repo:1.0",
    "memory": 1024,
    "cpu": 512,
    "essential": true,
    "entryPoint": ["/"],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOF
}