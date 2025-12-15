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
    public_subnet = module.vpc.public_subnet[*]
  
}