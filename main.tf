locals {
    #  Directories start with "C:..." on Windows; All other OSs use "/" for root.
    is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
}


provider "aws" {
    region      = var.region
    access_key  = var.access_key
    secret_key  = var.secret_key
    token       = var.token

    s3_use_path_style = true
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_requesting_account_id = true

    endpoints {
        apigateway     = "http://localhost:4566"
        apigatewayv2   = "http://localhost:4566"
        ec2            = "http://localhost:4566"
        s3             = "http://localhost:4566"
    }
}

resource "aws_security_group" "Hadoop_cluster_sc" {
    name = "Hadoop_cluster_sc"

    # inbound internet access
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # outbound internet access
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}


# namenode (master)
resource "aws_instance" "Namenode" {
    count = var.namenode_count
    ami = var.ami_image
    instance_type = var.instance_type
    key_name = var.aws_key_name
    tags = {
        Name = "s01"
    }
    private_ip = "172.31.0.101"
    vpc_security_group_ids = [aws_security_group.Hadoop_cluster_sc.id]

    metadata_options {
        http_endpoint  = "enabled"
        http_tokens    = "optional"
    }

    provisioner "file" {
        source      = "install-all.sh"
        destination = "/tmp/install-all.sh"

        connection {
            host     = self.public_ip
            type     = "ssh"
            user     = "root"
            private_key = file(var.amz_key_path)
	    timeout  = "1m"
        }
    }

   #  provisioner "file" {
   #      source      = "app/"
   #      destination = "/home/localstack/"
   # 
   #      connection {
   #          host     = self.public_ip
   #          type     = "ssh"
   #          user     = "root"
   #          private_key = file(var.amz_key_path)
   #      }
   # }

    # provisioner "local-exec" {
  # interpreter = local.is_windows ? ["PowerShell"] : []
  # command = <<EOT
    #cat ${var.key_path}/${var.key_name}.pub | ssh -o PasswordAuthentication=no  -o StrictHostKeyChecking=no -i ${var.amz_key_path} root@${self.public_ip} '
    #cat >> .ssh/authorized_keys &&
    #cat >> .ssh/id_rsa.pub' &&
    #cat ${var.key_path}/${var.key_name} | ssh -o PasswordAuthentication=no -o StrictHostKeyChecking=no -i ${var.amz_key_path} root@${self.public_ip} '
    #cat >> .ssh/id_rsa &&
    #service ssh restart
    #'
  #EOT
#}


    # provisioner "local-exec" {
    #     interpreter = local.is_windows ? ["PowerShell"] : []
    #     command = "cat ${var.key_path}/${var.key_name}.pub | ssh -o StrictHostKeyChecking=no -i ${var.amz_key_path}  root@${self.public_ip} 'cat >> .ssh/authorized_keys && service ssh restart'"
    # }
     # provisioner "local-exec" {
     #    interpreter = local.is_windows ? ["PowerShell"] : []
     #    command = "ssh root@{self.public_ip} 'service ssh restart'"
     #}
     #provisioner "local-exec" {
     #    interpreter = local.is_windows ? ["PowerShell"] : []
     #    command = "cat ${var.key_path}/${var.key_name}.pub | ssh -o StrictHostKeyChecking=no -i ${var.amz_key_path}  root@${self.public_ip} 'cat >> .ssh/id_rsa.pub'"
    # }
    # provisioner "local-exec" {
   #      interpreter = local.is_windows ? ["PowerShell"] : []
  #       command = "cat ${var.key_path}/${var.key_name} | ssh -o StrictHostKeyChecking=no -i ${var.amz_key_path}  root@${self.public_ip} 'cat >> .ssh/id_rsa'"
 #    }

    # # execute the configuration script
     provisioner "remote-exec" {
         inline = [
             "chmod +x /tmp/install-all.sh",
             "/bin/bash /tmp/install-all.sh",
             "/opt/hadoop-2.7.7/bin/hadoop namenode -format"
         ]
         connection {
             host     = self.public_ip
             type     = "ssh"
             user     = "root"
             private_key = file(var.amz_key_path)
         }

     }
}


# datanode (slaves)
resource "aws_instance" "Datanode" {
    count = var.datanode_count
    ami = var.ami_image
    instance_type = var.instance_type
    key_name = var.aws_key_name
    tags = {
        Name = lookup(var.hostnames, count.index)
    }
    private_ip = lookup(var.ips, count.index)
    vpc_security_group_ids = [aws_security_group.Hadoop_cluster_sc.id]

    metadata_options {
        http_endpoint  = "enabled"
        http_tokens    = "optional"
    }

    # # copy the initialization script to the remote machines
    # provisioner "file" {
    #     source      = "install-all.sh"
    #     destination = "/tmp/install-all.sh"

    #     connection {
    #         host     = self.public_ip
    #         type     = "ssh"
    #         user     = "root"
    #         private_key = file(var.amz_key_path)
    #     }
    # }

    # provisioner "local-exec" {
    #     interpreter = local.is_windows ? ["PowerShell"] : []
    #     command = "cat ${var.key_path}/${var.key_name}.pub | ssh -o StrictHostKeyChecking=no -i ${var.amz_key_path}  ubuntu@${self.public_ip} 'cat >> .ssh/authorized_keys'"
    # }
    # provisioner "local-exec" {
    #     interpreter = local.is_windows ? ["PowerShell"] : []
    #     command = "cat ${var.key_path}/${var.key_name}.pub | ssh -o StrictHostKeyChecking=no -i ${var.amz_key_path}  ubuntu@${self.public_ip} 'cat >> .ssh/id_rsa.pub'"
    # }
    # provisioner "local-exec" {
    #     interpreter = local.is_windows ? ["PowerShell"] : []
    #     command = "cat ${var.key_path}/${var.key_name} | ssh -o StrictHostKeyChecking=no -i ${var.amz_key_path}  ubuntu@${self.public_ip} 'cat >> .ssh/id_rsa'"
    # }

    # # execute the configuration script
    # provisioner "remote-exec" {
    #     inline = [
    #         "chmod +x /tmp/install-all.sh",
    #         "/bin/bash /tmp/install-all.sh",
    #     ]
    #     connection {
    #         host     = self.public_ip
    #         type     = "ssh"
    #         user     = "root"
    #         private_key = file(var.amz_key_path)
    #     }

    # }
}
