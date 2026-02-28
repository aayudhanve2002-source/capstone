resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  key_name = "linux-key"   # ← ADD THIS

  tags = {
    Name        = "${var.project_name}-bastion"
    Tier        = "management"
    Environment = "dev"
  }
}