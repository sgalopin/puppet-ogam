class ogam::mapserv {

    $enhancers = [ 'cgi-mapserver', 'mapserver-bin', 'gdal-bin', 'libapache2-mod-fcgid' ]
    package { $enhancers: ensure => 'installed' }

    file { "${ogam::conf_directory}/mapserver":
      ensure  => 'directory',
      recurse => true,
      source => "${ogam::git_clone_directory}/mapserver",
      group   => 'www-data',
    }->
    ext_file_line { 'mapserver_map_log_path':
      ensure => present,
      path   => "${ogam::conf_directory}/mapserver/ogam.map",
      match  => '(.*)/vagrant/ogam/website/htdocs/logs(.*)',
      line   => "\\1${ogam::log_directory}\\2",
	  multiple => true,
    }->
    ext_file_line { 'mapserver_map_conf_path':
      ensure => present,
      path   => "${ogam::conf_directory}/mapserver/ogam.map",
      match  => '(.*)/vagrant/ogam/mapserver(.*)',
      line   => "\\1${ogam::conf_directory}/mapserver\\2",
	  multiple => true,
    }

    # mapserv is a fcgi compatible, use default config sethandler with .fcgi
    file { '/usr/lib/cgi-bin/mapserv.fcgi':
        ensure  => link,
        target => '/usr/lib/cgi-bin/mapserv',
    }
}
