module "sg" {
    count = length(var.sg_name)
    source = "../../sg-module-now"
    sg_name =  var.sg_name[count.index]
    vpc_id =  local.vpc_id
    project =  var.project
    environment =  var.environment
    sg_tags = local.common_tags
}
