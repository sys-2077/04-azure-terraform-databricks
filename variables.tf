variable "env" {
  type    = string
  default = "dev"
}

variable "location" {
  default     = "East US"
  type = string
}

variable "workers" {
  default     = 2
  type = number
}

variable "node_type" {
  default     = "Standard_DS3_v2"
  type = string
}