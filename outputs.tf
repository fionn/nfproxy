output "nfproxy_eip_address" {
  description = "Elastic IP and hostname"
  value = {
    "public_ip"  = aws_eip.nfproxy.public_ip
    "public_dns" = aws_eip.nfproxy.public_dns
  }
}
