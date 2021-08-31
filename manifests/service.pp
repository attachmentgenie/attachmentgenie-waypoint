# Class to manage the waypoint service.
#
# @api private
class waypoint::service {
  if $::waypoint::manage_service {
    case $::waypoint::service_provider {
      'systemd': {
        ::systemd::unit_file { "${::waypoint::service_name}.service":
          content => template('waypoint/waypoint.service.erb'),
          before  => Service['waypoint'],
        }
      }
      default: {
        fail("Service provider ${::waypoint::service_provider} not supported")
      }
    }

    case $::waypoint::install_method {
      'archive': {}
      'package': {
        Service['waypoint'] {
          subscribe => Package['waypoint'],
        }
      }
      default: {
        fail("Installation method ${::waypoint::install_method} not supported")
      }
    }

    service { 'waypoint':
      ensure   => $::waypoint::service_ensure,
      enable   => true,
      name     => $::waypoint::service_name,
      provider => $::waypoint::service_provider,
    }
  }
}
