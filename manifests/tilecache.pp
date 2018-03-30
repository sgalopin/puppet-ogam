class ogam::tilecache {

    $enhancers = [ 'tilecache', 'python-flup', 'python-paste', 'python-imaging' ]
    package { $enhancers: ensure => 'installed' }

    file { '/etc/tilecache.cfg':
      ensure  => 'file',
      source => "${ogam::git_clone_directory}/vagrant_config/conf/tilecache/tilecache.cfg",
      backup => true,
      mode    => '0644',
    }->
    ext_file_line { 'tilecache_base_path':
      ensure => present,
      path   => '/etc/tilecache.cfg',
      match  => '(.*)@ogam::tilecache_directory@(.*)',
      line   => "\\1${ogam::tilecache_directory}\\2",
    }->
    file { '/usr/lib/python2.7/dist-packages/TileCache/Layer.py':
      ensure  => 'file',
      source => "${ogam::git_clone_directory}/vagrant_config/conf/tilecache/Layer.py",
      backup => true,
      mode    => '0644',
    }
}
