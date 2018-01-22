class ogam::mapserv (
    String $git_clone_directory = '/root/tmp/ogam/sources',
    String $conf_directory = '/etc/ogam',
    String $log_directory = '/var/log/ogam',
) {
    $enhancers = [ 'cgi-mapserver', 'mapserver-bin', 'gdal-bin', 'mapserver-doc', 'libapache2-mod-fcgid' ]
    package { $enhancers: ensure => 'installed' }

    file { "${conf_directory}/mapserver":
      ensure  => 'directory',
      recurse => true,
      source => "${git_clone_directory}/mapserver",
      group   => 'www-data',
    }
    # mapserv is a fcgi compatible, use default config sethandler with .fcgi
    file { '/usr/lib/cgi-bin/mapserv.fcgi':
        ensure  => link,
        target => '/usr/lib/cgi-bin/mapserv',
    }
    exec { [  "sed -i 's|/vagrant/ogam/website/htdocs/logs|${log_directory}|' ogam.map",
              "sed -i 's|/vagrant/ogam/mapserver|${conf_directory}/mapserver|' ogam.map" ]:
      path     	=> '/usr/bin:/usr/sbin:/bin',
      cwd 		  => "${conf_directory}/mapserver",
    }
}
