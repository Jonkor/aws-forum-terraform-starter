output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_dns_name" {
  description = "Use this DNS name to test the new backend before changing Route 53."
  value       = aws_lb.app.dns_name
}

output "alb_zone_id" {
  value = aws_lb.app.zone_id
}

output "nat_gateway_public_ip" {
  description = "Add this IP to the MongoDB Atlas Network Access allowlist."
  value       = aws_eip.nat.public_ip
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
