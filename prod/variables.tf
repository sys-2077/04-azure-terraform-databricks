variable "env" {
  type    = string
  default = "prod"
}

variable "location" {
  default     = "East US"
  type = string
}

variable "workers" {
  default     = 4
  type = number
}

variable "node_type" {
  default     = "Standard_DS4_v2"
  type = string
}