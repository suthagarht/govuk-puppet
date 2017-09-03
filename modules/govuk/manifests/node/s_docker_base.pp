# == Class: govuk::node::s_docker_base
#
# Base class for docker instances
#
class govuk::node::s_docker_base {

  include ::govuk::node::s_base
  include ::govuk_docker

  include ::govuk_containers::apps::swarm

  @ufw::allow {
    'swarm-cluster-management-communications':
      from => 'any',
      port => 2377;
    'swarm-communication-among-nodes-tcp':
      from  => 'any',
      proto => 'tcp',
      port  => 7946;
    'swarm-communication-among-nodes-udp':
      from  => 'any',
      proto => 'udp',
      port  => 7946;
    'swarm-overlay-network-traffic':
      from  => 'any',
      proto => 'udp',
      port  => 4789;
  }

}
