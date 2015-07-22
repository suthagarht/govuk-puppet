# Class: govuk_jenkins::config.pp
#
# This class templates the standard Jenkins configuration XML files.
# If configuration is not due to change often templating this config
# will help signficantly with deployment of new Jenkins machines,
# particularly in regarding to plugin configuration e.g. Github oauth.
#
# == Parameters:
#
# [*app_domain*]
#   The full domain for this environment. This is specifically used
#   within Location Configuration template.
#
# [*github_web_uri*]
#   Set the Github Web URI as required by the Github Oauth Plugin.
#
# [*github_api_uri*]
#   Set the Github API URI as required by the Github Oauth Plugin.
#
# [*github_client_id*]
#   The Github client ID is used as the user to authenticate against Github.
#
# [*github_client_secret*]
#   The Github client secret is used to authenticate against Github.
#
# [*users*]
#   List of users that have "2ndline" permissions in Jenkins.
#
# [*admins*]
#   List of admins that have "admin" permissions in Jenkins.
#
# [*manage_config*]
#   Option to manage the Jenkins config or not. This is set so we do not
#   overwrite configuration in live environments.
#
class govuk_jenkins::config (
  $app_domain = hiera('app_domain'),
  $github_web_uri = 'https://github.gds',
  $github_api_uri = 'https://github.gds/api/v3',
  $github_client_id,
  $github_client_secret,
  $users = [],
  $admins = [],
  $manage_config = false,
  ) {

      if $manage_config {

        validate_array($users)
        validate_array($admins)

        file { '/var/lib/jenkins':
          ensure  => directory,
          recurse => true,
          source  => 'puppet:///modules/govuk_jenkins/var/lib/jenkins',
          owner   => 'jenkins',
          group   => 'jenkins',
          notify  => Service['jenkins'],
        }

        file { '/var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml':
          ensure  => present,
          content => template('govuk_jenkins/config/jenkins.model.JenkinsLocationConfiguration.xml.erb'),
          owner   => 'jenkins',
          group   => 'jenkins',
          notify  => Service['jenkins'],
        }

        file { '/var/lib/jenkins/config.xml':
          ensure  => present,
          content => template('govuk_jenkins/config/config.xml.erb'),
          require => File['/var/lib/jenkins'],
          owner   => 'jenkins',
          group   => 'jenkins',
          notify  => Service['jenkins']
        }
      }
    }