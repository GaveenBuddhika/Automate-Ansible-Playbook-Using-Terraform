resource "null_resource" "manage_ec2_state" {
  triggers = {
    desired_state = var.ec2_state
    instance_id   = aws_instance.test_server2.id
  }

  provisioner "local-exec" {
    command = "ansible-playbook ansible/manage_state.yaml -e target_instance_id=${aws_instance.test_server2.id} -e target_region=${var.aws_region} -e target_state=${var.ec2_state}"      
  }
}
