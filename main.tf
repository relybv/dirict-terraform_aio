provider "openstack" {
  user_name  = "${var.user_name}"
  tenant_name = "${var.tenant_name}"
  password  = "${var.password}"
  insecure = true
  auth_url  = "${var.auth_url}"
}

# Template for aio cloud-init bash
resource "template_file" "init_aio" {
    template = "${file("init_aio.tpl")}"
    vars {
        monitor_address = "localhost"
        nfs_address = "localhost"
        db_address = "localhost"
    }
}

resource "openstack_compute_floatingip_v2" "aio" {
  region = "${var.region}"
  pool = "${var.pool}"
}

resource "openstack_compute_keypair_v2" "aio" {
  name = "SSH keypair for Terraform aio instances Customer ${var.customer} Environment ${var.environment}"
  region = "${var.region}"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}

resource "openstack_compute_secgroup_v2" "aio" {
  name = "terraform_${var.customer}_${var.environment}"
  region = "${var.region}"
  description = "Security group for the Terraform aio instances"
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "udp"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "aio" {
  name = "aio"
  region = "${var.region}"
  image_name = "${var.image_deb}"
  flavor_name = "${var.flavor_aio}"
  key_pair = "${openstack_compute_keypair_v2.aio.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.aio.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.aio.address}"
  user_data = "${template_file.init_aio.rendered}"
  network {
    name = "internal"
  }
}

