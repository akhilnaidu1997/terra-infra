variable "project" {
    default = "roboshop"
}
variable "environment" {
    default = "dev"
}
variable "sg_name" {
    default = [
        # databases
        "mongodb","redis","mysql","rabbitmq",
        #backend
        "catalogue","user","cart","shipping","payment",
        #frontend
        "frontend",
        #bastion
        "bastion",
        # backend-alb
        "backend-alb"
    ]
  
}