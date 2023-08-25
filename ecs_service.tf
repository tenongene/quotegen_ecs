resource "aws_ecs_cluster" "quotegen_app_cluster" {
  name = "quotegen_app_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
//======================================================>

resource "aws_ecs_cluster_capacity_providers" "qg_cluster_capacity_provider" {

  cluster_name = aws_ecs_cluster.quotegen_app_cluster.name

  capacity_providers = [ "${aws_ecs_capacity_provider.quotegen_ecs_capacity_provider.name}" ]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "${aws_ecs_capacity_provider.quotegen_ecs_capacity_provider.name}"
  }
}

//======================================================>

resource "aws_ecs_capacity_provider" "quotegen_ecs_capacity_provider" {
  name = "quotegen_ecs_capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.quotegen_ecs_asg.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
    }
  }
}

//================================================================>

resource "aws_ecs_service" "quotegen-svc" {

  name            = "quotegen-svc"
  cluster = aws_ecs_cluster.quotegen_app_cluster.arn

  task_definition = aws_ecs_task_definition.quotegen-task.arn
  desired_count   = 1


  load_balancer {
    target_group_arn = "${data.aws_lb_target_group.quotegen.arn}"
    container_name   = "quotegen-server-CONTAINER"
    container_port   = 7272
  }


  enable_execute_command = true

  



}

