output "customer" {
    value = "${var.customer}"
}

output "environment" {
    value = "${var.environment}"
}

output "aio server  address" {
    value = "${openstack_compute_floatingip_v2.aio.address}"
}


