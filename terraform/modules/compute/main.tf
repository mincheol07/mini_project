
resource "aws_instance" "bastion_host" {
    instance_type = var.instance_type_value
    ami = var.ami_value
    subnet_id = var.public_subnet_ids[0]

    key_name = aws_key_pair.key.id
    tags = {
        Name = "bastion_host"
    }
  
}


resource "aws_launch_template" "auto_template" {
    name = "auto_template"
    image_id = var.ami_value
    instance_type = var.instance_type_value

    

  
}