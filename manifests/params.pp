# == Class role_deployserver::params
#
# This class is meant to be called from role_deployserver.
# It sets variables according to platform.
#
class role_deployserver::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'role_deployserver'
      $service_name = 'role_deployserver'
    }
    'RedHat', 'Amazon': {
      $package_name = 'role_deployserver'
      $service_name = 'role_deployserver'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
