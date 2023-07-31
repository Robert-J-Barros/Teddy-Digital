variable "Name" {
  description = "nome da instancia"
  default     = "ServerOne"


}
variable "Region" {
  description = "região da instancia"
  default     = "us-east-1"

}
variable "Enviroment" {
  description = "ambiente de desenvolvimento"
  default     = "dev"
}
variable "Ami" {
  description = "AWS AMI utilizada"
  default     = "ami-053b0d53c279acc90"
}
variable "InstanceType" {
  description = "familia da instancia utilizada"
  default     = "t2.micro"
}
variable "KeyPair"{
    description = "chave privada que será usada para acessar o servidor"
    default = "fairness.tech"
}
variable "subnet_is"{
    description = ""
    default = "subnet-0221b70c69a8a42d0"
}
variable "subnet_is_for_bastion"{
    description = ""
    default = "subnet-07e9515feb1056d3c"
}
variable "AlbSecurityGroup"{
  description = "grupo de segurança do alb criado"
  default = "sg-0d714ce035fc89148"
}