variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

# TODO: remove or improve defaults
variable "proxy_destination_address" {
  type    = string
  default = "93.184.216.34" # example.com, :80/ returns 404
}

variable "proxy_destination_port" {
  type    = number
  default = 80
}

variable "proxy_source_port" {
  type    = number
  default = 222
}
