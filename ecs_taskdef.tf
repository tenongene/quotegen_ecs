resource "aws_ecs_task_definition" "quotegen-task" {
  family = "qg-place-container"

  network_mode = "bridge"
  requires_compatibilities = ["EC2"]

  execution_role_arn = "arn:aws:iam::688300040733:role/ecsTaskRole"
  task_role_arn = "arn:aws:iam::688300040733:role/ecsTaskRole"
  

  container_definitions = jsonencode([
    {
      name      = "${local.container_name}"
      image     = "tenongene/quotegen:latest"
      cpu       = 1024
      memory    = 512

      essential = true
      portMappings = [

        {
          containerPort = 80
          hostPort = 80
        }
      ]
    }
  ])

}
