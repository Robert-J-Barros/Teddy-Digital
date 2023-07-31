/*O código acima cria a VPC, 4 subnets (2 públicas e 2 privadas) em cada Availability Zone. 
Também cria o NAT para permitir a subnet privada acessar a internet


/* criando vpc */

resource "aws_vpc" "vpc_fase" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name       = var.environment
    Environment = var.environment
  }

}

/* Criando configurações de subnets Publicas */

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_fase.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags ={
    Name       = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = var.environment
  }
}

/* Criando configurações de subnets Privadas */

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc_fase.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name       = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = var.environment
  }
}
/*internet Gateway*/
resource "aws_internet_gateway" "InternetGateway" {
  vpc_id = aws_vpc.vpc_fase.id

  tags = {
    name       = "${var.environment}-igw"
    Environment = var.environment
  }
}
/* Elastic IP para o net */

resource "aws_eip" "NatElasticIp" {
  domain        = "vpc"
  depends_on = [aws_internet_gateway.InternetGateway]
}

/* NAT*/
resource "aws_nat_gateway" "Nat" {
  allocation_id = aws_eip.NatElasticIp.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.InternetGateway]

  tags = {
    name       = "${var.environment}-${element(var.availability_zones, 0)}-nat"
    Environment = var.environment
  }
}

/*tabela de rotas para a subnet privada*/

resource "aws_route_table" "PrivateRoute" {
  vpc_id = aws_vpc.vpc_fase.id

  tags = {
    Name        = "${var.environment}-Private-route-table"
    Environment = var.environment
  }

}
/*tabela de rotas para a subnet publica*/
resource "aws_route_table" "PublicRoute" {
  vpc_id = aws_vpc.vpc_fase.id
  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = var.environment
  }
}
/*definição de rotas*/
resource "aws_route" "PublicInternetGateway" {
  route_table_id         = aws_route_table.PublicRoute.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id         = aws_internet_gateway.InternetGateway.id
}
resource "aws_route" "PrivateNatGateway" {
  route_table_id         = aws_route_table.PrivateRoute.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.Nat.id
}

/*associação de tabela de rotas a subnets*/

resource "aws_route_table_association" "PublicAssosiation" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.PublicRoute.id
}

resource "aws_route_table_association" "PrivateAssosiation" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.PrivateRoute.id

}
resource "aws_security_group" "DefaulVpcFase" {
  name        = "${var.environment}-default-sg"
  description = "grupo padrao para a vpc fase"
  vpc_id      = aws_vpc.vpc_fase.id
  depends_on  = [aws_vpc.vpc_fase]


/*regras de entrada e saida */
ingress {
  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
  self      = true
}

egress {
  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
  self      = "true"
}
  tags = {
    Environment = "${var.environment}"
  }
}


