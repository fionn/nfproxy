output "nfproxy_address" {
  description = "Instance IPs and hostname"
  value = {
    "public_ip"  = aws_instance.nfproxy.public_ip
    "public_dns" = aws_instance.nfproxy.public_dns
  }
}
