class ogam::postgresql {

    class { 'postgresql::globals':
        encoding => 'UTF-8',
				#manage_package_repo => true, # Sets up official PostgreSQL repositories on your host if set to true.
        #version             => '9.5',
        #postgis_version     => '2.2',
    }->
		class { 'postgresql::server':
        listen_addresses => "127.0.0.1,${ogam::admin_ip_address},${ogam::host_ip_address}",
        manage_pg_hba_conf => true,
        port => 5432,
        postgres_password => postgresql_password($ogam::pg_user, $ogam::pg_password),
    }->
		file_line { 'client_min_messages':
			ensure => present,
			path   => '/etc/postgresql/9.6/main/postgresql.conf',
			match  => 'client_min_messages = .*',
			line   => 'client_min_messages = error', # https://www.postgresql.org/docs/9.6/static/runtime-config-logging.html (default : notice)
		}->
		file_line { 'log_min_messages':
			ensure => present,
			path   => '/etc/postgresql/9.6/main/postgresql.conf',
			match  => 'log_min_messages = .*',
			line   => 'log_min_messages = error', # (default : warning)
		}->
		file_line { 'log_min_error_statement':
			ensure => present,
			path   => '/etc/postgresql/9.6/main/postgresql.conf',
			match  => 'log_min_error_statement = .*',
			line   => 'log_min_error_statement = error', # (default : error)
		}

		# Installs the PostgreSQL postgis packages
		include postgresql::server::postgis

		# JDBC
		include postgresql::lib::java

		# Pg_hba_rule
		postgresql::server::pg_hba_rule { 'allow application network to access app database':
				description => "Open up PostgreSQL for access from ${ogam::host_ip_address}/32",
				type        => 'host',
				database    => 'ogam',
				user        => 'ogam',
				address     => "${ogam::host_ip_address}/32",
				auth_method => 'md5',
		}
		postgresql::server::pg_hba_rule { 'allow admin user to access app database':
        description => "Open up PostgreSQL for access from ${ogam::admin_ip_address}/32",
        type        => 'host',
        database    => 'all',
				user        => $ogam::pg_user,
        address     => "${ogam::admin_ip_address}/32",
        auth_method => 'md5',
    }

		file { '/root/.pgpass':
	    ensure  => 'file',
	    content => "localhost:5432:ogam:${ogam::pg_user}:${ogam::pg_password}\nlocalhost:5432:template1:${ogam::pg_user}:${ogam::pg_password}",
	    mode    => '0600',
	  }
}
