
resource "aws_instance" "test" {
    instance_type = var.instance_type_value
    ami = var.ami_value
    subnet_id = var.private_subnet_ids[0]

    key_name = aws_key_pair.key.id
    tags = {
        Name = "testec2"
    }
  
}