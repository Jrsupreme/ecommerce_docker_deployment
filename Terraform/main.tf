provider "aws" {                        # Provider
  access_key = var.access_key        
  secret_key = var.secret_key          
  region     = var.region 
}

module "VPC" {
  source = "./VPC"
}


module "EC2" {
  source = "./EC2"
  vpc_id = module.VPC.vpc_id
  public_subnet_id_1 = module.VPC.public_subnet_id_1
  public_subnet_id_2 = module.VPC.public_subnet_id_2
  private_subnet_id_1 = module.VPC.private_subnet_id_1
  private_subnet_id_2 = module.VPC.private_subnet_id_2

}

module "DB" {
  source = "./DB"
  vpc_id = module.VPC.vpc_id
  private_subnet_id_1 = module.VPC.private_subnet_id_1
  private_subnet_id_2 = module.VPC.private_subnet_id_2
  app_sg_id = module.EC2.app_sg_id
}


module "ALB" {
  source = "./ALB"
  vpc_id = module.VPC.vpc_id
  public_subnet_id_1 = module.VPC.public_subnet_id_1
  public_subnet_id_2 = module.VPC.public_subnet_id_2
  app_server_id_1 = module.EC2.app_server_id_1
  app_server_id_2 = module.EC2.app_server_id_2
}
