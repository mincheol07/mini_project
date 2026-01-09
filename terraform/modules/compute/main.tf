
resource "aws_instance" "bastion_host" {
    instance_type = var.instance_type_value
    ami = var.ami_value
    subnet_id = var.public_subnet_ids[0]

    vpc_security_group_ids = [var.security_group_bastion_id]
    

    key_name = aws_key_pair.key.id
    tags = {
        Name = "bastion_host"
    }
  
}

# auto scaling group 템플릿
resource "aws_launch_template" "auto_template" {
    name = "auto_template"
    image_id = var.ami_value
    instance_type = var.instance_type_value

    vpc_security_group_ids = [var.security_group_web_id]
    key_name = aws_key_pair.key.key_name

    monitoring {
      enabled = false
    }



    lifecycle {
      create_before_destroy = true
    }
    

    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "asg_instance"
      }
    }

    user_data = base64encode(<<-EOF
    #!/bin/bash
    # 1. 필요한 패키지 설치 (git, ansible)
    dnf update -y
    dnf install -y git ansible-core

    # 2. 작업 디렉토리 생성 및 이동
    WORKDIR="/home/ec2-user/ansible-setup"
    mkdir -p $WORKDIR
    
    # 3. 깃허브에서 플레이북 가져오기
    git clone https://github.com/mincheol07/mini_project.git $WORKDIR

    # 4. 앤서블 실행
    # -c local: 자기 자신에게 적용
    # setup.yml: 깃 레포 안에 있는 플레이북 파일 이름
    cd $WORKDIR/ansible
    ansible-playbook setup.yml -c local

    # 5. 로그 남기기
    echo "Ansible run completed at $(date)" >> /var/log/ansible-pull.log
  EOF
  )

  
}