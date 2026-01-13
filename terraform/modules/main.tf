module "vpc" {
    source = "./vpc"

    # 1. 필수 변수: vpc_az 전달
    vpc_az = [
        "ap-northeast-2a",
        "ap-northeast-2c"
    ]
    
    # 2. 필수 변수: public_subnet 전달 오브젝트 형식
    public_subnet = {
        "ap-northeast-2a-1" = { az = "ap-northeast-2a", cidr = "10.0.1.0/24"},
        "ap-northeast-2c-1" = { az = "ap-northeast-2c", cidr = "10.0.2.0/24"}
    }
    
    # 3. 필수 변수: private_subnet 전달 오브젝트 형식
    private_subnet = {
        "ap-northeast-2a-1" = { az = "ap-northeast-2a", cidr = "10.0.3.0/24"},
        "ap-northeast-2a-2" = { az = "ap-northeast-2a", cidr = "10.0.5.0/24"},
        "ap-northeast-2c-1" = { az = "ap-northeast-2c", cidr = "10.0.4.0/24"},
        "ap-northeast-2c-2" = { az = "ap-northeast-2c", cidr = "10.0.6.0/24"
    }
    
 }
}


module "network" {
    source = "./network"

    vpc_id = module.vpc.vpc_id
    public_subnet_ids = module.vpc.public_subnet[*]
    private_subnet_ids = module.vpc.private_subnet[*]

    cidr_block_all = "0.0.0.0/0"
    cidr_block_bastion = "10.0.1.0/24"
    ip_protocol_tcp = "tcp"

    cidr_block_private_web = [
        "10.0.3.0/24",
        "10.0.4.0/24"
    ]
  
}




module "compute" {
    source = "./compute"

    public_subnet_ids = module.vpc.public_subnet[*]
    private_subnet_ids = module.vpc.private_subnet[*]

    ami_value = "ami-0b818a04bc9c2133c"
    instance_type_value = "t2.micro"
    security_group_web_id = module.network.web_se_group
    security_group_bastion_id = module.network.bastion_se_group
  
}

module "asglb" {
    source = "./asglb"

    private_subnet_ids = [module.vpc.private_subnet[0], module.vpc.private_subnet[2]]
    group_name = "main_group"
    group_max_size = "5"
    group_min_size = "2"
    group_desired_capacity = "2"

    launch_config = module.compute.launch_template.id
    security_group_web = module.network.web_se_group
    vpc_id = module.vpc.vpc_id

    auto_group_policy_var = {
      name = "alb_group_policy"
      policy_type = "TargetTrackingScaling"
      predefined_metric_type = "ASGAverageCPUUtilization"
      target_value = 70.0
    }
    
    alb_var = {
      name = "main-alb"
      load_balancer_type = "application"
    }

    alb_target_group_var = {
      name = "alb-target-group"
      port = 80
      protocol = "HTTP"
      target_type = "instance"

      path = "/"
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 5
      interval = 10
      matcher = "200"
    }

    alb_listener_var = {
      port = "80"
      protocol = "HTTP"
      type = "forward"
    }

    public_subnet_ids = module.vpc.public_subnet
  
}

module "database" {
  source = "./database"

  db_subnet_group = [module.vpc.private_subnet[1], module.vpc.private_subnet[3]]
  db_password = var.db_password
}