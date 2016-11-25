# == Class: role_deployserver
#
# Full description of class role_deployserver here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class role_deployserver
{
  # a role includes one or more profiles and at least a 'base' profile

  class { '::profile_base':  }
  class { '::profile_puppetmaster':
    require      => Class['::profile_base'],
  }

}
