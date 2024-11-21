output "app_server_id_1" {
  value = aws_instance.app_server1.id
}

output "app_server_id_2" {
  value = aws_instance.app_server2.id
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}