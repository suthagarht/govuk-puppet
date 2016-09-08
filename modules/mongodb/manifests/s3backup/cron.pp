# == Class: mongodb::s3backup::cron
#
# Runs a backup of MongoDB to Amazon S3 as a cron job.
#
# [*user*]
#   The user to run the cronjob as.
#
#
class mongodb::s3backup::cron(
  $user = 'govuk-backup',
  $realtime_hour = '*',
  $realtime_minute = '*/15',
  $daily_hour = 0,
  $daily_minute = 0,
) {

  include ::backup::client
  require mongodb::s3backup::package
  require mongodb::s3backup::backup

  # Here we use setlock to prevent the jobs from running asynchronously
  cron { 'mongodb-s3backup-realtime':
    command => '/usr/bin/setlock -n /etc/unattended-reboot/no-reboot/mongodb-s3backup /usr/local/bin/mongodb-backup-s3',
    user    => $user,
    hour    => $realtime_hour,
    minute  => $realtime_minute,
  }

  cron { 'mongodb-s3-night-backup':
    command => '/usr/bin/setlock /etc/unattended-reboot/no-reboot/mongodb-s3backup /usr/local/bin/mongodb-backup-s3 daily',
    user    => $user,
    hour    => $daily_hour,
    minute  => $daily_minute,
  }

  # FIXME Please remove resource once merged
  file { '/var/lock/mongodb-s3backup':
    ensure => absent,
  }

}
