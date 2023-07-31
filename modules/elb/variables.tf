variable "ZoneId" {
    description = "id da zona de dns"
    default     = "Z0978075OIA9XI4XDLGL"
  
}
variable "Name" {
    description = "nome de registro"
    default     = "fase2.fairness.tech"
  
}
variable "Enviroment" {
    description = "nome do ambiente"
    default     = "Dev"
}
variable "ArnCertificate" {
    description = "registro de certificado ssl pela acm"
    default = "arn:aws:acm:us-east-1:479254302146:certificate/d3b1763b-ddd6-4c04-8b03-2b454f3aacb5"
  
}
variable "PublicSubnets"{
    description = "subnets privadas no qual os recurcos estarão"
    default    = ["subnet-07e9515feb1056d3c","subnet-01668e947471d737a"]
} 
variable "InstanceIds"{
    description = "instancia que será anexada ao target group"
    default = "i-0d82ee16989b268e8"
}   