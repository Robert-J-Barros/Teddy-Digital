variable "region" {
  description = "denifi a região que a instancia será lançada"
  default     = "us-east-1"
}
variable "name" {
  description = "name of application"
  default     = "server01"
}
variable "env" {
  description = "Enviroment of the application"
  default     = "prod"
}
variable "ami" {
  description = "AMI used for instance"
  default     = "ami-05548f9cecf47b442"
}
variable "instance_type" {
  description = "instance family for server"
  default     = "t2.micro"
}
variable "repo" {
  description = "repositorio"
  default     = "https://github.com"
}
variable "vpc_cidr" {
  description = "valor do bloco de ip da subnet"
  default     = "192.168.0.0/16"
}
variable "environment" {
  description = "Define o nome do ambiente"
  default     = "dev"
}
variable "public_subnets_cidr" {
  description = "define os blocos de ip para as duas subnets publicas"
  default     = ["192.168.0.0/24", "192.168.1.0/24"]
}
variable "private_subnets_cidr" {
  description = "define os blocos de ip para as duas subnets publicas"
  default     = ["192.168.2.0/24", "192.168.3.0/24"]
}
variable "availability_zones" {
  description = "availability zones no qual as subnets são criadas"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", ]
}



