# == Class role_deployserver::install
#
# This class is called from role_deployserver for install.
#
class role_deployserver::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $::role_deployserver::package_name:
    ensure => present,
  }
}
