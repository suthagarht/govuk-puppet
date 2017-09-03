# == Define: Govuk_docker::Swarm
#
# Manage a Docker Swarm
#
# === Parameters:
#
# [*role*]
#   The role of the node. Either "worker" or "manager".
#
# [*manager_ips*]
#   An array of IPs assigned to the managers.
#
# [*manager_token*]
#   After the cluster has been created, the manager token should be retrieved
#   and passed into this value. Only then will further managers be able to join
#   to the cluster.
#
# [*worker_token*]
#   After the cluster has been created, the worker token should be retrieved
#   and passed into this value. Only then will workers be able to join
#   to the cluster.
#
# [*ensure*]
#   Whether to set everything up.
#
define govuk_docker::swarm (
  $role,
  $manager_ips,
  $manager_token = undef,
  $worker_token = undef,
  $ensure = 'present',
){
  include ::govuk_docker
  validate_re($role, [ 'worker', 'manager' ])
  validate_array($manager_ips)

  if $role == "manager" {
    # Managers are snowflakes, we do creation by hand
    file { "/usr/local/bin/swarm_create_cluster":
      ensure  => $ensure,
      mode    => '0775',
      content => template("govuk_docker/swarm_create_cluster.erb"),
    }

    if $manager_token {
      # Join managers to a cluster by hand
      file { "/usr/local/bin/swarm_manager_join":
        ensure  => $ensure,
        mode    => '0775',
        content => template("govuk_docker/swarm_manager_join.erb"),
      }
    }
  } else {
    if $worker_token {
      file { "/usr/local/bin/swarm_worker_join":
        ensure  => $ensure,
        mode    => '0775',
        content => template("govuk_docker/swarm_worker_join.erb"),
      }

      # Workers should be able to be dynamically created and scaled
      exec { 'Swarm worker join':
        command => '/usr/local/bin/swarm_worker_join',
        require => File['/usr/local/bin/swarm_worker_join'],
      }
    }
  }
}
