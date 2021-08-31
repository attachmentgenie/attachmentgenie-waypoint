# Class to install waypoint.
#
# @api private
class waypoint::install {
  if $::waypoint::manage_user {
    user { 'waypoint':
      ensure => present,
      home   => $::waypoint::install_dir,
      name   => $::waypoint::user,
    }
    group { 'waypoint':
      ensure => present,
      name   => $::waypoint::group
    }
  }
  case $::waypoint::install_method {
    'package': {
      if $::waypoint::manage_repo {
        class { 'waypoint::repo': }
      }
      package { 'waypoint':
        ensure => $::waypoint::package_version,
        name   => $::waypoint::package_name,
      }
    }
    'archive': {
      file { 'waypoint install dir':
        ensure => directory,
        group  => $::waypoint::group,
        owner  => $::waypoint::user,
        path   => $::waypoint::install_dir,
      }
      if $::waypoint::manage_user {
        File[$::waypoint::install_dir] {
          require => [Group['waypoint'],User['waypoint']],
        }
      }

      archive { 'waypoint archive':
        cleanup      => true,
        creates      => "${::waypoint::install_dir}/waypoint",
        extract      => true,
        extract_path => $::waypoint::install_dir,
        group        => $::waypoint::group,
        path         => '/tmp/waypoint.tar.gz',
        source       => $::waypoint::archive_source,
        user         => $::waypoint::user,
        require      => File['waypoint install dir']
      }

    }
    default: {
      fail("Installation method ${::waypoint::install_method} not supported")
    }
  }
}
