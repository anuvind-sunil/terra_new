variable "vpc_cidr" {
  default = ["10.5.0.0/16"]
}
variable "public_subnets" {
    default = ["10.5.1.0/24","10.5.2.0/24"] 
}
variable "private_subnets" {
    default = ["10.5.3.0/24","10.5.4.0/24"] 
}
variable "availability_zone" {
    default = ["ap-southeast-1a","ap-southeast-1b","ap-southeast-1c"]  
}
variable "vpc_name" {
}
variable "igw_name" {
}
