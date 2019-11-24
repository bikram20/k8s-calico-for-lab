output "instances_id" {
  description = "List of IDs of instances"
  value       = "${join(",", module.cali_instances_masters.id, module.cali_instances_workers.id)}"
}

output "instances_ip" {
  description = "List of IPs of instances"
  value       = "${join(",", module.cali_instances_masters.private_ip, module.cali_instances_workers.private_ip)}"
}


output "public_ip_master" {
  description = "Public IP of master"
  value = module.cali_instances_masters.public_ip
}

output "public_ip_workers" {
  description = "Public IP of workers"
  value = module.cali_instances_workers.public_ip
}

