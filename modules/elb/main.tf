resource "aws_security_group" "ElasticSg"{
  name = "${var.Enviroment}-elb-security"
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
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
}
}

#criando load balancer
resource "aws_alb" "ApplicationLoadBalancer" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ElasticSg.id]
  subnets            = var.PublicSubnets

  enable_deletion_protection = false
  tags = {
    Environment = "production"
  }
}
#criando target group
resource "aws_alb_target_group" "ApplicationLoadBalancerTarget"{
    name = var.Enviroment
    port = 80
    protocol = "HTTP"
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
    health_check {
      path = "/salvar"
      port = 80
    }
}
#adicionando instancia ao target group:
resource "aws_lb_target_group_attachment" "AtacchInstanceTargeGroup" {
  target_group_arn = aws_alb_target_group.ApplicationLoadBalancerTarget.arn
  target_id        = var.InstanceIds  
}
#criando listeners
resource "aws_alb_listener" "HttpListener" {
  load_balancer_arn = aws_alb.ApplicationLoadBalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ApplicationLoadBalancerTarget.arn
    type             = "forward"
  }
  depends_on  = [aws_alb.ApplicationLoadBalancer]
}

resource "aws_alb_listener" "HttpsListener" {
  load_balancer_arn = aws_alb.ApplicationLoadBalancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.ArnCertificate}"
  default_action {
    target_group_arn = aws_alb_target_group.ApplicationLoadBalancerTarget.arn
    type             = "forward"
  }
  depends_on  = [aws_alb.ApplicationLoadBalancer]
}


#criando route 53
#resource "aws_route53_record" "FairnessRecord" {
#  zone_id = var.ZoneId
#  name    = var.Name
#  type    = "A"
#  alias{
#    name  = aws_alb.ApplicationLoadBalancer.dns_name
#    zone_id = var.ZoneId
#    evaluate_target_health = true
#  }
#  allow_overwrite = true
#  depends_on  = [aws_alb.ApplicationLoadBalancer]
#}



resource "aws_route53_record" "FairnessRecord" {
  zone_id = "${var.ZoneId}"
  name    = "${var.Name}"
  type    = "CNAME"
  ttl     = 300

  records = ["${aws_alb.ApplicationLoadBalancer.dns_name}"]
}