resource "aws_security_group" "worker_management" {
  name_prefix = "worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.210.0.0/24",
    ]
  }
}
