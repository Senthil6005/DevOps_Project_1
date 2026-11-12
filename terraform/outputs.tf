output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "jenkins_ssh" {
  value = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.jenkins.public_ip}"
}

output "app_url" {
  value = "http://${aws_instance.app.public_ip}"
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}
