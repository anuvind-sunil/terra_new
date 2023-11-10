output "id" {
    value = aws_instance.eks_terra_nat_inst.id
}
output "dependency_db_ins" {
  value=aws_instance.eks_terra_nat_inst
}