class govuk::apps::publisher( $port = 3000 ) {

  govuk::app { 'publisher':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/',
    asset_pipeline    => true,
  }

  $service_desc = 'publisher local authority data importer error'

  file { '/usr/local/bin/local_authority_import_check':
    ensure  => present,
    mode    => '0755',
    content => template('govuk/local_authority_import_check.erb'),
  }

  @@nagios::passive_check { "check-local-authority-data-importer-${::hostname}":
    service_description => $service_desc,
    host_name           => $::fqdn,
    freshness_threshold => 28 * (60 * 60),
  }

}
