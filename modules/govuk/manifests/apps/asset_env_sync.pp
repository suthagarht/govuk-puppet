# class: govuk::apps::asset_env_sync
#
# Environment for syncing Asset Manager assets from production
# to staging and integration.
#
# === Parameters
#
# [*aws_access_key_id*]
#   AWS access key for a user with permission to write to the S3 bucket
# [*aws_secret_access_key*]
#   AWS secret key for a user with permission to write to the S3 bucket
# [*enabled*]
#   Determines whether the environment is made available
#
class govuk::apps::asset_env_sync(
  $aws_access_key_id = undef,
  $aws_secret_access_key = undef,
  $enabled = false,
) {

  $app_name = 'asset-env-sync'

  if $enabled {
    package { 'awscli':
      ensure   => 'present',
      provider => 'pip',
    }

    # Ensure config dir exists
    file { "/etc/govuk/${app_name}":
      ensure  => 'directory',
      purge   => true,
      recurse => true,
      force   => true,
    }

    # Ensure env dir exists
    file { "/etc/govuk/${app_name}/env.d":
      ensure  => 'directory',
      purge   => true,
      recurse => true,
      force   => true,
    }

    Govuk::App::Envvar {
      app => $app_name,
      notify_service => false,
    }

    govuk::app::envvar {
      "${title}-AWS_ACCESS_KEY_ID":
        varname => 'AWS_ACCESS_KEY_ID',
        value   => $aws_access_key_id;
      "${title}-AWS_SECRET_ACCESS_KEY":
        varname => 'AWS_SECRET_ACCESS_KEY',
        value   => $aws_secret_access_key;
    }
  }
}
