class govuk_elasticsearch (
  $version = 'present',
  $cluster_hosts = ['localhost'],
  $cluster_name = 'elasticsearch',
  $heap_size = '512m',
  $number_of_shards = '5',
  $number_of_replicas = '1',
  $minimum_master_nodes = '1',
  $host = 'localhost',
  $log_index_type_count = {},
  $disable_gc_alerts = false
) {
  anchor { 'govuk_elasticsearch::begin': }

  $http_port = '9200'
  $transport_port = '9300'

  class { 'elasticsearch_old':
    version              => $version,
    cluster_hosts        => $cluster_hosts,
    cluster_name         => $cluster_name,
    heap_size            => $heap_size,
    http_port            => $http_port,
    number_of_shards     => $number_of_shards,
    number_of_replicas   => $number_of_replicas,
    minimum_master_nodes => $minimum_master_nodes,
    host                 => $host,
    transport_port       => $transport_port,
    log_index_type_count => $log_index_type_count,
    disable_gc_alerts    => $disable_gc_alerts,
    require              => Anchor['govuk_elasticsearch::begin'],
    before               => Anchor['govuk_elasticsearch::end'],
  }

  class { 'govuk_elasticsearch::monitoring':
    host_count           => size($cluster_hosts),
    cluster_name         => $cluster_name,
    http_port            => $http_port,
    log_index_type_count => $log_index_type_count,
    disable_gc_alerts    => $disable_gc_alerts,
  }

  @ufw::allow { "allow-elasticsearch-http-${http_port}-from-all":
    port => $http_port,
  }

  @ufw::allow { "allow-elasticsearch-transport-${transport_port}-from-all":
    port => $transport_port;
  }

  anchor { 'govuk_elasticsearch::end': }
}
