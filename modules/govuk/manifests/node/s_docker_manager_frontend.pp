# == Class: govuk::node::s_docker_manager_frontend
#
# A Docker Swarm manager for frontend cluster
#
# === Parameters:
#
# [*manager_ips*]
#   Create an array of static IPs that are assigned to the managers
#   in a cluster.
#
# [*manager_token*]
#   The token used to join managers to the cluster.
#
class govuk::node::s_docker_manager_frontend (
  $manager_ips = [],
  $manager_token = undef,
) {

  include ::govuk::node::s_docker_base

  govuk_docker::swarm { "frontend_cluster_manager_${::hostname}":
    role           => 'manager',
    manager_ips    => $manager_ips,
    $manager_token => $manager_token,
    require        => Class['::govuk::node::s_docker_base'],
  }

  Govuk_containers::Cluster::App <| tag == frontend |>

}
