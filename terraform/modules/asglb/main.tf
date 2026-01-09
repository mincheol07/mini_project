 resource "aws_autoscaling_group" "main_group" {


    vpc_zone_identifier = var.private_subnet_ids

    name = var.group_name
    max_size = var.group_max_size
    min_size = var.group_min_size
    desired_capacity = var.group_desired_capacity


    # launch_configuration = var.launch_config

    launch_template {
      id = var.launch_config
      version = "$Latest"
    }

    health_check_type = "ELB"
    health_check_grace_period = 300

    force_delete = true
    termination_policies = ["OldestInstance"]
    target_group_arns = [ aws_lb_target_group.main_alb_target_group.arn ]

    tag {
      key = "main_auto_group"
      value = "asg-instance"
      propagate_at_launch = true # 오래된 인스턴스부터 정리
    }
       
 }



 resource "aws_autoscaling_policy" "main_auto_group_policy" {
    name = var.auto_group_policy_var.name
    autoscaling_group_name = aws_autoscaling_group.main_group.name
    policy_type = var.auto_group_policy_var.policy_type


    target_tracking_configuration {
      
      predefined_metric_specification {
        predefined_metric_type = var.auto_group_policy_var.predefined_metric_type
      }

      target_value = var.auto_group_policy_var.target_value

      disable_scale_in = true
    }

 }



 resource "aws_lb" "main_alb" {
    name = var.alb_var.name
    internal = false
    load_balancer_type = var.alb_var.load_balancer_type

    subnets = var.public_subnet_ids
    security_groups = [var.security_group_web]
    

    tags = {
      Name = "main alb"
    }
   
 }

 
 resource "aws_lb_target_group" "main_alb_target_group" {

  name = var.alb_target_group_var.name
  port = var.alb_target_group_var.port
  protocol = var.alb_target_group_var.protocol
  target_type = var.alb_target_group_var.target_type

  vpc_id = var.vpc_id


  health_check {
    path = var.alb_target_group_var.path
    healthy_threshold = var.alb_target_group_var.healthy_threshold
    unhealthy_threshold = var.alb_target_group_var.unhealthy_threshold
    timeout = var.alb_target_group_var.timeout
    interval = var.alb_target_group_var.interval
    matcher = var.alb_target_group_var.matcher
  }

  tags = {
    Name = "alb target group"
  }
   
 }


 resource "aws_lb_listener" "main_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port = var.alb_listener_var.port
  protocol = var.alb_listener_var.protocol
  default_action {
    type = var.alb_listener_var.type
    target_group_arn = aws_lb_target_group.main_alb_target_group.arn
  }

  tags = {

    Name = "alb listener"
  }
   
 }