resource "aws_security_group" "SgBastion" {
  name = "${var.Enviroment}-bastion"
  description = "grupo de seguranca para instancia ec2 bastion"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id 

  /*permitir o ssh */
  ingress{
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
}
}

resource "aws_security_group" "SgFaseDois" {
  name = var.Enviroment
  description = "grupo de seguranca para instancia ec2"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id 

  /*permitir o ssh */
  ingress{
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 0
    protocol  = "tcp"
    to_port   = 65535
    security_groups = [var.AlbSecurityGroup]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
}
}
resource "aws_instance" "ServOne" {
  ami           = var.Ami
  instance_type = var.InstanceType
  subnet_id = var.subnet_is
  key_name = var.KeyPair
  vpc_security_group_ids = [aws_security_group.SgFaseDois.id]
  tags = {
    Name        = var.Name
    Enviroment  = var.Enviroment
    Provisioner = "Terraform"
  }
}
resource "aws_instance" "Bastion" {
  ami           = var.Ami
  instance_type = var.InstanceType
  subnet_id = var.subnet_is_for_bastion
  key_name = var.KeyPair
  vpc_security_group_ids = [aws_security_group.SgBastion.id]
  tags = {
    Name        = "${var.Name}-bastion"
    Enviroment  = var.Enviroment
    Provisioner = "Terraform"
  }
}