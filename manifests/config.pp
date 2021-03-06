# Class: spark::config
#
# This module manages the spark configuration directories
#
# Parameters:
#
# [print_cmd] when 1 spark-executor will print running command
#
# [paths] extra paths to be included on Spark classpath
#
#
# Requires: spark::install, spark
#
# Sample Usage: include spark::config
#
class spark::config(
  $mesos_master,
  $local_ip,
  $executor_uri      = '',
  $home              = '/usr/share/spark',
  $scala_version     = '2.9.3-400',
  $scala_home        = '/usr',
  $scala_lib         = '/usr/share/java',
  $mesos_lib         = '/usr/local/lib/libmesos.so',
  $print_cmd         = '1',
  $paths             = [], # extra class paths
  $console_log_level = 'INFO', # INFO, ERROR, WARN
  ) {

  validate_array($paths)

  file_line { 'etc_profile_mesos_lib':
    path => '/etc/profile',
    line => 'export MESOS_NATIVE_LIBRARY="$mesos_lib"',
  }

  file_line { 'etc_profile_scala_home':
    path => '/etc/profile',
    line => 'export SCALA_HOME="$scala_home"',
  }

  file_line { 'etc_profile_scala_lib_path':
    path => '/etc/profile',
    line => 'export SCALA_LIBRARY_PATH="$scala_lib"',
  }

  file { "${home}/conf/spark-env.sh":
    ensure => 'present',
    content => template("spark/spark-env.sh.erb"),
#   owner => $user,
#   group => $group,
    mode => 0644,
  }

  file { "${home}/conf/log4j.properties":
    ensure => 'present',
    content => template("spark/log4j.properties.erb"),
#   owner => $user,
#   group => $group,
    mode => 0644,
  }

}
