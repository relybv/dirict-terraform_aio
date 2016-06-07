resource "null_resource" "post_checks_aio" {
  triggers {
    cluster_instance_ids = "${openstack_compute_instance_v2.aio.id}"
  }
  connection {
    host = "${openstack_compute_instance_v2.aio.network.0.floating_ip}"
    user = "debian"
    private_key = "~/.ssh/id_rsa.terraform"
  }
  provisioner "remote-exec" {
    script = "wait_provision.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo /opt/puppetlabs/puppet/bin/rspec /usr/local/rspec_tests/ -f d"
    ]
  }
}

