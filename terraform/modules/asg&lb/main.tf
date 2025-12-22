 resource "aws_autoscaling_group" "main_group" {


    vpc_zone_identifier = var.private_subnet_ids

    name = var.group_name
    max_size = var.group_max_size
    min_size = var.group_min_size
    desired_capacity = var.group_desired_capacity


    launch_configuration = var.launch_config



       
 }