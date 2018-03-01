# Class: ogam
# ===========================
#
# Full description of class ogam here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'ogam':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class ogam (
    String $vhost_servername = 'agent.example.com',
    String $admin_ip_address = "192.168.50.1",
    String $host_ip_address = $ipaddress_eth1,
    String $pg_user = 'postgres',
    String $pg_password = 'postgres',
    String $app_name = 'myapp'
) {

    package { 'unzip': ensure => 'installed' }

    # Directories paths
    $tmp_directory            = "/root/tmp/${app_name}"
    $git_clone_directory      = "/var/www/${app_name}"
    $local_scripts_directory  = "${tmp_directory}/scripts"
    $conf_directory           = "/etc/${app_name}"
    $www_directory            = "${git_clone_directory}/website/htdocs/server/ogamServer"
    # The docroot_directory must be a direct subdir of the www_directory
    $docroot_directory        = "${www_directory}/web"
    $tilecache_directory      = "/var/www/tilecache"
    # If you set the server upload dir in a subdir of /var/tmp be aware of the apache service "PrivateTmp" parameter.
    $server_upload_directory  = "${www_directory}/upload"
    $service_upload_directory = "/var/tmp/${app_name}/service_upload"
    $log_directory            = "/var/log/${app_name}"
    $tomcat_directory         = "/var/lib/tomcat8"

    # Defaults directories
    file { [ '/root/tmp',
             $tmp_directory,
             $git_clone_directory,
             $local_scripts_directory, ]:
        ensure  => directory,
        mode    => '0700',
    }
    file { $conf_directory:
        ensure  => directory,
        group => 'www-data',
        mode    => '0750',
    }
    file { [ '/var/www',
             $www_directory,
             $docroot_directory, ]:
        ensure => 'directory',
        group => 'www-data',
        mode => '0750'
    }
    file { [  $tilecache_directory,
              "${tilecache_directory}/cache", ]:
        ensure  => directory,
        group => 'www-data',
        mode    => '0770',
    }
    file { $log_directory:
        ensure  => directory,
        group => 'www-data',
        mode    => '0770',
    }
    file { [ $server_upload_directory,
         "${server_upload_directory}/images", ]:
        ensure  => directory,
        group => 'www-data',
        mode    => '0770',
    }
    group { 'tomcat8':
        ensure => 'present',
    }->
    file { [ "/var/tmp/${app_name}",
             $service_upload_directory ]:
        ensure  => directory,
        group => 'tomcat8',
        mode    => '0770',
    }

    # Class
    include ogam::java
    include ogam::git
    include ogam::postgresql
    include ogam::tomcat
    include ogam::apache
    include ogam::sencha
    include ogam::mapserv
    include ogam::tilecache
    include ogam::tasks
}
