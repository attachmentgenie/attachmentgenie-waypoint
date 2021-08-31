# Class to install and configure waypoint.
#
# Use this module to install and configure waypoint.
#
# @example Declaring the class
#   include ::waypoint
#
# @param archive_source Location of waypoint binary release.
# @param group Group that owns waypoint files.
# @param install_dir Location of waypoint binary release.
# @param install_method How to install waypoint.
# @param manage_repo Manage the waypoint repo.
# @param manage_service Manage the waypoint service.
# @param manage_user Manage waypoint user and group.
# @param package_name Name of package to install.
# @param package_version Version of waypoint to install.
# @param service_name Name of service to manage.
# @param service_provider Init system that is used.
# @param service_ensure The state of the service.
# @param user User that owns waypoint files.
class waypoint (
  String[1] $group,
  Stdlib::Absolutepath $install_dir,
  Enum['archive','package'] $install_method ,
  Boolean $manage_repo,
  Boolean $manage_service,
  Boolean $manage_user,
  String[1] $package_name,
  String[1] $package_version,
  String[1] $service_name,
  String[1] $service_provider,
  Enum['running','stopped'] $service_ensure,
  String[1] $user,
  Optional[Stdlib::HTTPUrl] $archive_source = undef,
) {
  anchor { 'waypoint::begin': }
  -> class{ '::waypoint::install': }
  -> class{ '::waypoint::config': }
  ~> class{ '::waypoint::service': }
  -> anchor { 'waypoint::end': }
}
