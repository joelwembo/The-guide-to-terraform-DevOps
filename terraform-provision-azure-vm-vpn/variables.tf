# https://github.com/claranet/terraform-azurerm-regions/blob/master/regions.tf
variable "resourcegroup" {
  description = "ProdxCloudResourceGroup2"
  default = "ProdxCloudResourceGroup2"
  type = string
}

variable "location" {
  description = "australiacentral"
  default = "australiacentral"
  type = string
}

variable "size" {
  description = "Image Size"
  default = "Standard_F2"
  type = string
  
}


variable "admin_username" {
  description = "admin username"
  default = "ubuntu"
  type = string
  
}

variable "admin_password" {
  description = "admin password"
  default = "abcde@123456"
  type = string
  
}