# Netfilter Reverse Proxy

## Introduction

Turnkey solution for an in-kernel high performance reverse proxy.

This deploys a `t2.micro` EC2 instance and returns an elastic IP address.
Traffic sent to this IP address on port `var.proxy_source_port` will be proxied to `var.proxy_destination_address` at port `var.proxy_destination_port`.

## Configuration

You must specify:
- `proxy_destination_address`, the IPv4 address you want to proxy traffic to,
- `proxy_destination_port`, the port on the destination machine to send traffic to,
- `proxy_source_port`, the port the proxy machine will listen on.

## Deployment

```bash
terraform apply
```
