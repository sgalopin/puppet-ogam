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
class ogam  {

    package { 'unzip': ensure => 'installed' }

    # Directories paths
    $git_clone_directory      = '/root/tmp/ogam/sources'
    $local_scripts_directory  = '/root/tmp/ogam/scripts'
    $conf_directory           = '/etc/ogam'
    $docroot_directory        = '/var/www/ogam/web'
    $tilecache_directory      = '/var/www/tilecache'
    $tmp_directory            = '/var/tmp/ogam'
    $log_directory            = '/var/log/ogam'
    $tomcat_directory         = '/var/lib/tomcat8'

    # Defaults directories
    file { [ '/root/tmp',
             '/root/tmp/ogam',
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
    file { [ '/var/www/ogam',
              $docroot_directory, ]:
        ensure => 'directory',
        #owner => 'www-data',
        group => 'www-data',
        mode => '0750'
    }
    file { [  $tilecache_directory,
              "${tilecache_directory}/cache", ]:
        ensure  => directory,
        group => 'www-data',
        mode    => '0770',
    }
    file { $tmp_directory:
        ensure  => directory,
        group => 'www-data',
        mode    => '0771',
    }
    file { $log_directory:
        ensure  => directory,
        group => 'www-data',
        mode    => '0770',
    }

    # Class
    include ogam::java
    class {'ogam::git':
        git_clone_directory => $git_clone_directory
    }
    class {'ogam::postgresql':
        git_clone_directory => $git_clone_directory,
        tmp_directory => $tmp_directory,
    }
    class {'ogam::tomcat':
        git_clone_directory => $git_clone_directory,
        tmp_directory => $tmp_directory,
    }
    class {'ogam::apache':
        docroot_directory => $docroot_directory,
        log_directory => $log_directory,
        conf_directory => $conf_directory,
    }
    class {'ogam::sencha':
        local_scripts_directory => $local_scripts_directory,
        tmp_directory => $tmp_directory,
    }
    class {'ogam::mapserv':
        git_clone_directory => $git_clone_directory,
        conf_directory => $conf_directory,
        log_directory => $log_directory,
    }
    class {'ogam::tilecache':
        git_clone_directory => $git_clone_directory,
        tilecache_directory => $tilecache_directory,
    }
    class {'ogam::tasks':
        docroot_directory => $docroot_directory,
        git_clone_directory => $git_clone_directory,
        local_scripts_directory => $local_scripts_directory,
        tmp_directory => $tmp_directory,
        tomcat_directory => $tomcat_directory,
    }
}
