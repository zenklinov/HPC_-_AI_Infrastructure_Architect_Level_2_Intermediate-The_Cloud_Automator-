output "instance_public_ip" {
  description = "Public IP of the AI Inference Server"
  value       = aws_instance.ai_server.public_ip
}

output "api_endpoint" {
  description = "API Endpoint for inference"
  value       = "http://${aws_instance.ai_server.public_ip}/predict"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i private_key.pem ubuntu@${aws_instance.ai_server.public_ip}"
}
