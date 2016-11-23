# == Class role_deployserver::config
#
# This class is called from role_deployserver for service config.
#
class role_deployserver::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

}
