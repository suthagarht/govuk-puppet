# == Class: govuk::node::s_docker_worker_frontend
#
# A Docker Swarm worker for frontend cluster
#
# === Parameters:
#
# [*manager_ips*]
#   Create an array of static IPs that are assigned to the managers
#   in a cluster.
#
# [*worker_token*]
#   The token used to join workers to the cluster.
#
class govuk::node::s_docker_worker_frontend (
  $manager_ips  = [],
  $worker_token = undef,
) {

  include ::govuk::node::s_docker_base

  govuk_docker::swarm { "frontend_cluster_worker_${::hostname}":
    role         => 'worker',
    manager_ips  => $manager_ips,
    worker_token => $worker_token,
    require      => Class['::govuk::node::s_docker_base'],
  }

}
