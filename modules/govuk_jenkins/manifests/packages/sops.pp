# == Class: govuk_jenkins::packages::sops
#
# Installs sops https://github.com/mozilla/sops
#
# === Parameters
#
# [*apt_mirror_hostname*]
#   The hostname of an APT mirror
#
class govuk_jenkins::packages::sops (
  $apt_mirror_hostname = undef,
  $version = '3.0.2',
){

  apt::source { 'sops':
    location     => "http://${apt_mirror_hostname}/sops",
    release      => $::lsbdistcodename,
    architecture => $::architecture,
    key          => '3803E444EB0235822AA36A66EC5FE1A937E3ACBB',
  }

  package { 'sops':
    ensure  => $version,
    require => Apt::Source['sops'],
  }

}
