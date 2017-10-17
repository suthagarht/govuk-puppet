# == Class: Govuk_containers::Apps::Swarm
#
# Create all the apps that are running in a Docker Swarm
#
# === Parameters:
#
# [*apps*]
#   A hash of all the apps that can be passed to the defined type
#   that creates all the appropriate things required to monitor
#   an app in Docker Swarm.
#
class govuk_containers::apps::swarm (
  $apps = {},
) {
  validate_hash($apps)

  create_resources("@govuk_containers::cluster::app", $apps)
}
