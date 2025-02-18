# # Create ECS Cluster
# resource "aws_ecs_cluster" "cluster" {
#   name = var.cluster_name
# }

# # ECS Task Definition (simplified for demo)
# # resource "aws_ecs_task_definition" "task" {
# #   family                   = "nginx-task"
# #   container_definitions    = jsonencode([{
# #     name      = "nginx-container"
# #     image     = var.ecr_repository_url
# #     cpu       = 256
# #     memory    = 512
# #     essential = true
# #   }])
# #   network_mode             = "awsvpc"
# #   task_role_arn         = var.task_role_arn
# #   execution_role_arn    = var.execution_role_arn
# # }


# resource "aws_ecs_task_definition" "task" {
#   family                   = "nginx-task"
#   cpu                      = "256"    # Minimum for Fargate
#   memory                   = "512"    # Minimum for Fargate
#   network_mode             = "awsvpc" # Required for Fargate
#   requires_compatibilities = ["FARGATE"] # Specify Fargate compatibility

#   container_definitions = jsonencode([{
#     name      = "nginx"
#     image     = "nginx:latest"
#     essential = true
#     portMappings = [
#       {
#         containerPort = 80
#         hostPort      = 80
#         protocol      = "tcp"
#       }
#     ]
#   }])
# }


# # module "alb" {
# #   source          = "../alb"  # Adjust the path to your elb module
# # #   security_groups = var.security_groups
# # #   subnets         = var.subnets
# #   #vpc_id          = var.vpc_id  # Ensure VPC ID is passed
# # }

# resource "aws_ecs_service" "service" {
#   name            = "nginx-service"
#   cluster         = var.cluster_name
#   task_definition = aws_ecs_task_definition.task.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"  # Make sure this is specified
#   network_configuration {
#    # subnets          = module.vpc.private_subnet_ids
#     subnets          = var.subnets
#     assign_public_ip = true  # Set to true if you need a public IP
#     #security_groups  = [aws_security_group.alb_sg.id]
#     security_groups  = var.security_groups
#   }

# #   load_balancer {
# #     target_group_arn = var.alb_target_group_arn  # Reference the passed ALB target group ARN
# #     container_name   = "nginx"  # Name of the container
# #     container_port   = 80      # Port exposed by the container
# #   }

#   depends_on = [module.alb]  # Ensure ALB is created before ECS service
# }


# # resource "aws_ecs_service" "service" {
# #   name            = "nginx-service"
# #   cluster         = aws_ecs_cluster.cluster.id
# #   task_definition = aws_ecs_task_definition.task.arn
# #   desired_count   = 1
# #   launch_type     = "FARGATE"

# #   network_configuration {
# #     subnets          = var.public_subnets
# #     security_groups = var.security_groups
# #     assign_public_ip = true
# #   }

# #   load_balancer {
# #     target_group_arn = var.alb_target_group_arn  # Reference the passed ALB target group ARN
# #     container_name   = "nginx-container"
# #     container_port   = 80
# #   }

# #   #depends_on = [aws_lb.main]  # Ensure ALB is created before ECS service
# # }

# Define the ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

# ECS Task Definition for Nginx
resource "aws_ecs_task_definition" "task" {
  family                   = "nginx-task"
  cpu                      = "256"    # Minimum required for Fargate
  memory                   = "512"    # Minimum required for Fargate
  network_mode             = "awsvpc" # Required for Fargate
  requires_compatibilities = ["FARGATE"] # Ensure Fargate compatibility

  container_definitions = jsonencode([{
    name      = "nginx"
    image     = "nginx:latest"
    essential = true
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }
    ]
  }])
}

# ECS Service Configuration
resource "aws_ecs_service" "service" {
  name            = "nginx-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true  # Assign public IP if needed
    security_groups  = var.security_groups
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "nginx"
    container_port   = 80
  }
  # Ensure ALB is provisioned before creating ECS service
  #depends_on = [module.alb]
  #depends_on = [var.alb_arn]
  #depends_on = [aws_lb_target_group.target_group]  #  This ensures ALB Target Group exists
  depends_on = [
    # var.alb_arn,  # Ensure ALB is provisioned before ECS service
    # var.alb_target_group_arn  # Ensure Target Group is linked
    #aws_lb_listener.http,  # Wait for ALB Listener
    #aws_lb_target_group.target_group,  # Ensure Target Group is linked
    var.alb_listener_arn
  ]

}
