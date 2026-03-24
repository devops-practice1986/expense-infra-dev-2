# # import vpn public key
# resource "aws_key_pair" "vpn" {
#   key_name = "vpn"
#   # this is file function to import public key into vpn
#   #public_key = file("/d/devops-practice/openvpn.pub")
#   #public_key = file("D:/devops-practice/openvpn.pub")

#   public_key = file("~/.ssh/openvpn.pub")
# }

resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("D:/devops-practice/terraform-repo/expense-infra-dev-2/openvpn.pub")
}

module "vpn" {
  source   = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.openvpn.key_name

  ami = data.aws_ami.inspiredevops.id

  name                   = local.resource_name
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    var.common_tags,
    var.vpn_tags,
    {
      Name = local.resource_name
    }
  )
}
