module "vpc_launch" {
  source = "./vpc"
  vpc_name = "anuvind_vpc"
  vpc_cidr="10.5.0.0/16"
  public_subnets=["10.5.1.0/24","10.5.2.0/24"]
  private_subnets = ["10.5.3.0/24","10.5.4.0/24"] 
  availability_zone = ["ap-southeast-1a","ap-southeast-1b","ap-southeast-1c"]  
  igw_name = "anuvind_igw"
}



module "nat_ec2_launch" {
  source = "./ec2"
  ami_id = "ami-078c1149d8ad719a7"
  subnetting =  module.vpc_launch.subnet_data_1
  name = "anuvind_nat_instance"
  network_interface = module.vpc_launch.netinterface

}

module "eks_launch" {
  source   = "./eks"
  subnet_1 = module.vpc_launch.subnet_data_1
  subnet_2 = module.vpc_launch.subnet_data_2
  cluster_name = "anuvind_eks_cluster"
}

module "node_launch" {
  source  = "./node"
  cluster = module.eks_launch.cluster_name
  subnets =  [module.vpc_launch.subnet_data_1,module.vpc_launch.subnet_data_2]
}


module "ec2_testing" {
  source = "./ec2_test_inst"
  subnet_id = module.vpc_launch.priv_subnet_data_1
  vpc_id = module.vpc_launch.vpc
  dependency_db_ins= module.nat_ec2_launch.dependency_db_ins
}