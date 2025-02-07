variable "region" {
    type = string
    default = "us-east-1"
}

variable "access_key" {
    type = string
    default = "test"
}

variable "secret_key" {
    type = string
    default = "test"
}

variable "token" {
    type = string
    default = null
}

variable "instance_type" {
    type = string
    default = "m5.xlarge"               # change instance type if needed
}

variable "ami_image" {
    type = string
    default = "ami-df5de72bdb3b"   # ubuntu image
}

variable "key_name" {
    type = string
    default = "localkey"                # key name, see readme
}

variable "key_path" {
    type = string
    default = "."                       # change directory to local .ssh directory e.g. ~/.ssh/
}

variable "aws_key_name" {
    type = string
    default = "amznkey"                  # key name, see readme
}

variable "amz_key_path" {
    type = string
    default = "/opt/code/spark-terraform/amznkey.pem"
}

variable "namenode_count" {
    type = number
    default = 1                         # count = 1 = 1 aws EC2
}

variable "datanode_count" {
    type = number
    default = 3                         # count = 3 = 3 aws EC2
}

variable "ips" {
    default = {
        "0" = "172.31.0.102"
        "1" = "172.31.0.103"
        "2" = "172.31.0.104"
        "3" = "172.31.0.105"
        "4" = "172.31.0.106"
        "5" = "172.31.0.107"
    }
}

variable "hostnames" {
    default = {
        "0" = "s02"
        "1" = "s03"
        "2" = "s04"
        "3" = "s05"
        "4" = "s06"
        "5" = "s07"
    }
}
