# == Class: govuk::node::s_development
#
# GOV.UK development VM.
#
# === Parameters
#
# [*apps*]
#   An array of applications that should be included on this machine.
#
class govuk::node::s_development (
  $apps = [],
) {
  include base

  include assets::user
  include clamav::run_fake_virus_scan
  include golang
  include govuk_apt::disable_pipelining
  include govuk_mysql::libdev
  include govuk_rabbitmq
  include hosts::development
  include imagemagick
  include mailhog
  include memcached
  include mongodb::server
  include mysql::client
  include nodejs
  include redis
  include tmpreaper

  include govuk_python
  include govuk_testing_tools

  include govuk_rbenv::all

  include router::assets_origin
  include router::draft_assets

  $app_classes = regsubst($apps, '^', 'govuk::apps::')
  include $app_classes

  # Check when Puppet last ran and recommend that people run it if it's
  # out-of-date by >=3 days.
  file { '/etc/profile.d/last_puppet_run.sh':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/govuk/etc/profile.d/devvm_last_puppet_run.sh',
  }

  # Install additional bash completions.
  package { 'bash-completion':
    ensure  => present,
  }

  file { '/etc/bash_completion.d/git-completion.bash':
    ensure => present,
    source => 'puppet:///modules/govuk/etc/bash_completion.d/git-completion.bash',
  }

  include govuk_java::openjdk7::jdk
  include govuk_java::openjdk7::jre
  class { 'govuk_java::set_defaults':
    jdk => 'openjdk7',
    jre => 'openjdk7',
  }

  class { 'govuk_elasticsearch':
    cluster_name           => 'govuk-development',
    heap_size              => '1024m',
    number_of_shards       => '1',
    number_of_replicas     => '0',
    minimum_master_nodes   => '1',
    open_firewall_from_all => true,
    require                => Class['govuk_java::set_defaults'],
  }

  include nginx

  nginx::config::vhost::default { 'default': }
  nginx::config::site { 'development':
    source => 'puppet:///modules/nginx/development',
  }

  # No `root_password` means that none will be set.
  # Rather than a hash of an hash empty string.
  class { 'govuk_mysql::server': }

  mysql::db {
    ['collections_publisher_development', 'collections_publisher_test']:
      user     => 'collections_pub',
      password => 'collections_publisher';

    ['contacts_development', 'contacts_test']:
      user     => 'contacts',
      password => 'contacts';

    ['release_development', 'release_test']:
      user     => 'release',
      password => 'release';

    ['search_admin_development', 'search_admin_test']:
      user     => 'search_admin',
      password => 'search_admin';

    [
      'signonotron2_development',
      'signonotron2_test',
      'signonotron2_integration_test',
    ]:
      user     => 'signonotron2',
      password => 'signonotron2';

    [
      'whitehall_development',
      'whitehall_test',
      'whitehall_test1',
      'whitehall_test2',
      'whitehall_test3',
      'whitehall_test4',
    ]:
      user     => 'whitehall',
      password => 'whitehall';
  }

  include govuk_postgresql::server::standalone
  include govuk_postgresql::client
  include postgresql::server::contrib

  # Create the vagrant user role with permission to create databases.
  #
  # Note: we do not explicitly create the development/test versions of the
  # databases via puppet, it is expected that databases will be created in
  # development using the `rake db:create` command.
  postgresql::server::role {
    'vagrant':
      password_hash => postgresql_password('vagrant', 'vagrant'),
      createdb      => true;
  }

  # The mapit role needs to be a superuser in order to load the PostGIS
  # extension for the test database.
  postgresql::server::role {
    'mapit':
      superuser     => true,
      password_hash => postgresql_password('mapit', 'mapit');
  }

  package {
    'sqlite3':        ensure => 'installed'; # gds-sso uses sqlite3 to run its test suite
    'vegeta':         ensure => installed; # vegeta is used by the router test suite
    'mawk-1.3.4':     ensure => installed; # Provides /opt/mawk required by pre-transition-stats
  }

  ensure_packages(['wkhtmltopdf'])
}
