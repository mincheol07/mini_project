resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key" {
  key_name   = "my-key"  # 그냥 이렇게
  public_key = tls_private_key.key.public_key_openssh
}