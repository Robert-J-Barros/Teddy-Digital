output "SecurityGroupId" {
  value = aws_security_group.ElasticSg.id
}
output "AlbSubnetId" {
  value = aws_alb.ApplicationLoadBalancer.subnets
}
