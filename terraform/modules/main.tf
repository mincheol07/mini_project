module "vpc" {
    source = "./vpc"

    # 1. 필수 변수: vpc_az 전달
    vpc_az = [
        "ap-northeast-2a",
        "ap-northeast-2c"
    ]
    
    # 2. 필수 변수: public_subnet 전달 (Key = AZ, Value = CIDR)
    public_subnet = {
        "ap-northeast-2a" = "10.0.1.0/24",
        "ap-northeast-2c" = "10.0.2.0/24"
    }
    
    # 3. 필수 변수: private_subnet 전달 (Key = AZ, Value = CIDR)
    private_subnet = {
        "ap-northeast-2a" = "10.0.3.0/24",
        "ap-northeast-2a" = "10.0.5.0/24",
        "ap-northeast-2c" = "10.0.4.0/24"
        "ap-northeast-2c" = "10.0.6.0/24",
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
    instance_type_value = "t2.miro"
    security_group_id = module.network.web_se_group
  
}

module "asg&lb" {
    source = "./asg&lb"

    private_subnet_ids = [module.vpc.private_subnet[0], module.vpc.private_subnet[2]]
    group_name = "main_group"
    group_max_size = "5"
    group_min_size = "2"
    group_desired_capacity = "2"

    launch_config = module.compute.launch_template

  
}