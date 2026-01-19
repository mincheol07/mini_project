
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
    # 1. 패키지 설치
    dnf update -y
    dnf install -y git ansible-core

    # 2. 작업 폴더 준비 및 권한 설정
    WORKDIR="/home/ec2-user/ansible-setup"
    mkdir -p $WORKDIR
    # 깃 클론을 위해 폴더 주인을 ec2-user로 변경
    chown ec2-user:ec2-user $WORKDIR

    # 3. 깃허브에서 최신 코드 가져오기
    # 주의: 이미 폴더가 있으면 에러 날 수 있으니 비어있는 상태에서 수행
    git clone https://github.com/mincheol07/mini_project.git $WORKDIR

    # 4. 환경 변수를 시스템 전체 설정에 등록 (핵심)
    # 이렇게 해야 나중에 Gunicorn이 실행될 때 이 값들을 읽을 수 있습니다.
    cat <<EOT > /etc/profile.d/flask_env.sh
    export DB_HOST="${var.db_address}"
    export DB_USER="${var.db_username}"
    export DB_PASSWORD="${var.db_password}"
    export DB_NAME="${var.db_name}"
    EOT

    # 현재 실행 중인 이 쉘에도 즉시 적용
    source /etc/profile.d/flask_env.sh

    # 5. 앤서블 플레이북 실행
    cd $WORKDIR/ansible
    ansible-playbook setup.yml -c local \
      -e "db_host=${var.db_address}" \
      -e "db_user=${var.db_username}" \
      -e "db_password=${var.db_password}" \
      -e "db_name=${var.db_name}"

    # 6. 완료 로그 기록
    echo "Deployment finished at $(date)" >> /var/log/user_data.log
  EOF
  )

  
}