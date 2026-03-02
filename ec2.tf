
resource "aws_instance" "test_server2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name        = "test_server2"
    
  }
}