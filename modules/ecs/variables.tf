variable "repository_name" {
    description = "nome do repositorio ecr"
    default     = "my-app"
  
}

variable "ZoneId" {
    description = "id da zona de dns"
    default     = "Z0978075OIA9XI4XDLGL"
  
}
variable "Name" {
    description = "nome de registro"
    default     = "fase3.fairness.tech"
  
}
variable "vpc_id" {
  description = "vcp id"
  default     = "vpc-000a954966ed445fb"
}
variable  subnets_ids{
  description = "id dos security group"
  default = "subnet-0221b70c69a8a42d0"  ###
} 
variable "aws_region" {
  default     = "eu-east-1"
  description = "aws region where our resources going to create choose"
  #replace the region as suits for your requirement
}

variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "app_image" {
  default     = "479254302146.dkr.ecr.us-east-1.amazonaws.com/nginx:renew"
  description = "docker image to run in this ECS cluster"
}

variable "app_port" {
  default     = "80"
  description = "portexposed on the docker image"
}

variable "app_count" {
  default     = "2" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  default     = "1024"
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "fargate_memory" {
  default     = "2048"
  description = "Fargate instance memory to provision (in MiB) not MB"
}

variable "PublicSubnets"{
    description = "subnets privadas no qual os recurcos estarão"
    default    = ["subnet-07e9515feb1056d3c","subnet-01668e947471d737a"]
} 