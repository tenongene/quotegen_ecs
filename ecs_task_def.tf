resource "aws_ecs_task_definition" "quotegen-task" {
  family = "quotegen_ecs_task"

  network_mode = "bridge"
  requires_compatibilities = ["EC2"]

  execution_role_arn = "arn:aws:iam::688300040733:role/ecsTaskExecutionRole"
  task_role_arn = "arn:aws:iam::688300040733:role/ecsTaskRole"
  

  container_definitions = jsonencode([
    {
      name      = "quotegen-server-CONTAINER"
      image     = "tenongene/quotegen:latest"
      cpu       = 1024
      memory    = 512
      essential = true
      portMappings = [

        {
          containerPort = 7272
          hostPort = 80
        }
      ]
    }
  ])

}