class ogam::apache {

    # APACHE Install
    class { 'apache': # contains package['httpd'] and service['httpd']
        default_vhost => false,
        mpm_module => 'prefork', # required per the php module
        log_level => 'debug' # https://httpd.apache.org/docs/2.4/mod/core.html#loglevel (default : warn)
    }

    # APACHE Modules
    # 'libapache2-mod-php7.0' package required on debian (stretch) to avoid a bug... (but not on ubuntu-16.04)
    # 'php-xml' and 'php-mbstring' packages required per phpunit 
    package { [ 'libapache2-mod-php7.0', 'php-pgsql', 'php-xml', 'php-mbstring' ]:
      ensure => 'installed'
    }->
    class { 'apache::mod::php': }->
    file_line { 'error_reporting':
      ensure => present,
      path   => '/etc/php/7.0/apache2/php.ini',
      match  => 'error_reporting = .*',
      line   => 'error_reporting = E_ALL', # http://php.net/manual/fr/function.error-reporting.php
    }->
    file_line { 'display_errors':
      ensure => present,
      path   => '/etc/php/7.0/apache2/php.ini',
      match  => 'display_errors = .*',
      line   => 'display_errors = Off',
    }->
    file_line { 'display_startup_errors':
      ensure => present,
      path   => '/etc/php/7.0/apache2/php.ini',
      match  => 'display_startup_errors = .*',
      line   => 'display_startup_errors = Off',
    }->
    file_line { 'log_errors':
      ensure => present,
      path   => '/etc/php/7.0/apache2/php.ini',
      match  => 'log_errors = .*',
      line   => 'log_errors = On',
    }

    include apache::mod::rewrite
    include apache::mod::expires
    include apache::mod::cgi
    include apache::mod::fcgid

    # APACHE Parameters
    # include apache::params # contains common config settings
    # $vhost_dir= $apache::params::vhost_dir
    # $user= $apache::params::user
    # $group= $apache::params::group

    # APACHE Virtual host
    apache::vhost { $ogam::vhost_servername:
        servername => $ogam::vhost_servername,
        port    => '80',
        docroot => $ogam::docroot_directory,
        manage_docroot => false,
        docroot_owner => 'www-data',
        docroot_group => 'www-data',
        options => ['Indexes','FollowSymLinks','MultiViews'],
        directoryindex => 'app_dev.php',
        php_values => {
            'post_max_size' => '100M',
            'upload_max_filesize' => '100M',
            'opcache.revalidate_freq' => '3',
            'xdebug.default_enable' => 'false',
        },
        php_admin_values => {
            'realpath_cache_size' => '64k',
            'opcache.interned_strings_buffer' => '8M',
            'opcache.max_accelerated_files' => '4000',
            'opcache.memory_consumption' => '128M',
            'opcache.fast_shutdown' => '1',
        },
        directories => [{
          path => $ogam::docroot_directory,
          override => 'None',
          require => 'all granted',
          options => ['-MultiViews'],
          rewrites => [
            {
              comment      => 'Redirection to Symfony',
              rewrite_cond => ['%{REQUEST_FILENAME} !-f'],
              rewrite_rule => ['^(.*)$ app_dev.php [QSA,L]'],
            },
          ],
        },{
          path => "${ogam::docroot_directory}/bundles",
          custom_fragment => 'RewriteEngine Off',
        },{
          path => "${ogam::docroot_directory}/OgamDesktop",
          custom_fragment => 'RewriteEngine Off',
        },{
          path => "${ogam::git_clone_directory}/website/htdocs/client",
          custom_fragment => 'RewriteEngine Off',
        },{
          path => "/mapserv-ogam",
          provider => 'location',
          custom_fragment => "
SetEnv MS_MAPFILE \"${ogam::conf_directory}/mapserver/ogam.map\"
SetEnv MS_ERRORFILE \"${ogam::log_directory}/mapserver_ogam.log\"
SetEnv MS_DEBUGLEVEL 5", # http://mapserver.org/fr/development/rfc/ms-rfc-28.html
        },{
          path => "/tilecache-ogam",
          provider => 'location',
        }],
        aliases => [
            {
                alias => '/odd',
                path  => "${ogam::docroot_directory}/OgamDesktop",
            },{
                alias => '/client',
                path  => "${ogam::git_clone_directory}/website/htdocs/client",
            },{
                scriptalias => '/mapserv-ogam',
                path  => "/usr/lib/cgi-bin/mapserv.fcgi",
            },{
                scriptalias => '/tilecache-ogam',
                path  => "/usr/lib/cgi-bin/tilecache.fcgi",
            }
        ]
    }
}
