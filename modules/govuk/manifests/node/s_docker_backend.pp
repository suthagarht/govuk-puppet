# == Class: govuk::node::s_docker_backend
#
class govuk::node::s_docker_backend {

  include ::govuk::node::s_base

  include ::govuk_containers::frontend::haproxy
  include ::govuk_containers::apps::release

}
