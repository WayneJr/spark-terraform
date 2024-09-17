output "Datanode_dns_address" {
    value = aws_instance.Datanode.*.public_dns
}

output "Namenode_dns_address" {
    value = aws_instance.Namenode.*.public_dns
}

output "Datanode_private_dns_address" {
    value = aws_instance.Datanode.*.private_dns
}

output "Namenode_private_dns_address" {
    value = aws_instance.Namenode.*.private_dns
}

output "Namenode_public_ip" {
    value = aws_instance.Namenode.*.public_ip
}

output "Datanode_public_ip" {
    value = aws_instance.Datanode.*.public_ip
}


# output "Datanode_private_ip" {
#     value = aws_instance.Datanode.*.private_ip
# }

# output "Namenode_private_ip" {
#     value = aws_instance.Namenode.*.private_ip
# }

output "Datanode_id" {
    value = aws_instance.Datanode.*.id
}

output "Namenode_id" {
    value = aws_instance.Namenode.*.id
}