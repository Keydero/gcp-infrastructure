variable "env" {
  default = "dev"
}

variable "project" {
  type = string
}

variable "cf_functions" {
  type = map(map(string))
  default = {
    "name-your-cloud-function" = {},
  }
}

