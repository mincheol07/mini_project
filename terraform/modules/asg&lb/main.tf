 resource "aws_autoscaling_group" "main_group" {


    vpc_zone_identifier = var.private_subnet_ids

    name = var.group_name
    max_size = var.group_max_size
    min_size = var.group_min_size
    desired_capacity = var.group_desired_capacity


    launch_configuration = var.launch_config

    health_check_type = "ELB"
    health_check_grace_period = 300

    force_delete = true
    termination_policies = ["OldestInstance"]

    tag {
      key = "main_auto_group"
      value = "asg-instance"
      propagate_at_launch = true # 오래된 인스턴스부터 정리
    }



       
 }


 resource "aws_autoscaling_policy" "main_auto_group_policy" {
    name = "main_auto_group_policy"
    autoscaling_group_name = aws_autoscaling_group.main_group.name
    policy_type = "TargetTrackingScaling"


    target_tracking_configuration {
      
      predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
      }

      target_value = 70.0

      disable_scale_in = true
    }
   
 }


 resource "aws_lb" "main_alb" {
    name = "main_lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [var.security_group_web]
    
   
 }