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
  include ::profile_base
  include ::profile_puppetmaster
}
