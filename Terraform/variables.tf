variable secret_key {
    type = string
    sensitive = true
}

variable access_key {
    type = string
    sensitive = true
}

variable "region" {
  default = "us-east-1"
}

