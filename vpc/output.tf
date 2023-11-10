output "subnet_data_1" {
  value = aws_subnet.eks_pubsubnet[0].id
}
output "subnet_data_2" {
  value = aws_subnet.eks_pubsubnet[1].id
}
output "priv_subnet_data_1" {
  value = aws_subnet.eks_privsubnet[0].id
}
output "priv_subnet_data_2" {
  value = aws_subnet.eks_privsubnet[1].id
}
output "vpc"{
  value = aws_vpc.vpc_eks_learn.id
}

output "table_id" {
  value = aws_route_table.EKS_route_table_private.id
}

output "netinterface" {
  value = aws_network_interface.public_instance_network_interface.id
}