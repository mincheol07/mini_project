resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key" {
  key_name   = "my-key"  
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "key_file" {
  content  = tls_private_key.key.private_key_pem
  filename = "${path.module}/my-key.pem" # 현재 폴더에 저장
  
  # 리눅스/맥 사용자라면 권한 설정이 필수입니다 (600)
  file_permission = "0600"
}