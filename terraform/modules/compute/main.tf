module "vpc" {
  source = "../vpc"

  vpc_cidr = "10.0.0.0/16"
  vpc_region = "ap-northeast-2"
}

resource "aws_instance" "test" {
    instance_type = "t2.miro"
    ami = "ami-0b818a04bc9c2133c"
    subnet_id = module.vpc.subnet_ids[2]

    key_name = aws_key_pair.key.id
    tags = {
        Name = "testec2"
    }
  
}