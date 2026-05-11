variable "prefix" {
  default = "platform"
}

variable "environment" {
  default = "dev"
}

variable "monthly_budget" {
  default = 30
}

variable "alert_email" {
  default = "leoworths@gmail.com"
}

locals {
  name_prefix = "${var.prefix}-${var.environment}"

  tags = {
    environment = var.environment
    owner       = "platform-team"
    costcenter  = "platform"
  }
}