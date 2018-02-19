class ogam::tilecache {

    $enhancers = [ 'tilecache', 'python-flup', 'python-paste', 'python-imaging' ]
    package { $enhancers: ensure => 'installed' }

    file { '/etc/tilecache.cfg':
      ensure  => 'file',
      source => "${ogam::git_clone_directory}/vagrant_config/conf/tilecache/tilecache.cfg",
      backup => true,
      mode    => '0644',
    }->
    exec { "sed -i 's|/var/www/tilecache|${ogam::tilecache_directory}|' tilecache.cfg":
      path     	=> '/usr/bin:/usr/sbin:/bin',
      cwd 		  => "/etc",
    }
    file { '/usr/lib/python2.7/dist-packages/TileCache/Layer.py':
      ensure  => 'file',
      source => "${ogam::git_clone_directory}/vagrant_config/conf/tilecache/Layer.py",
      backup => true,
      mode    => '0644',
    }
}
