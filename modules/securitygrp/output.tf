output "jenkins_sg_name" {
  description = "The name of the Jenkins security group"
  value       = aws_security_group.jenkins_sg.name
}