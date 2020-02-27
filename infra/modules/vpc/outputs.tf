output "public_subnets" {
  value = [aws_subnet.public-1.id, aws_subnet.public-2.id, aws_subnet.public-3.id]
}

output "private_subnets" {
  value = [aws_subnet.private-1.id, aws_subnet.private-2.id, aws_subnet.private-3.id]
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}
