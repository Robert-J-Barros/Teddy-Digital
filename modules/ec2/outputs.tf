output "public_ip" {
  value = ["${aws_instance.ServOne.public_ip}"]
}