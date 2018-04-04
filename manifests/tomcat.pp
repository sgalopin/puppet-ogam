class ogam::tomcat {

    $enhancers = [ 'gradle', 'libgnumail-java' ]
    package { $enhancers: ensure => 'installed' }
    # Note: 'libpostgresql-jdbc-java' already installed with postgresql

    # Note: The tomcat8 user, the service and the default instance
    # are done via the installation of the package
    tomcat::install { $ogam::tomcat_directory:
        install_from_source => false,
        package_ensure => 'present',
        package_name => 'tomcat8',
    }->
    # https://tomcat.apache.org/tomcat-8.0-doc/logging.html#Considerations_for_production_usage
    ext_file_line { 'tomcat_handlers':
			ensure => present,
			path   => '/etc/tomcat8/logging.properties',
			match  => '^(\.*)handlers = (.*), java.util.logging.ConsoleHandler',
			line   => '\1handlers = \2',
      multiple => true,
		}->
    ext_file_line { 'tomcat_logs_level':
      ensure => present,
      path   => '/etc/tomcat8/logging.properties',
      match  => '(.*).level = (.*)',
      line   => '\1.level = SEVERE', # https://tomcat.apache.org/tomcat-8.0-doc/logging.html
      multiple => true,
    }->
    file { "${ogam::tomcat_directory}/lib":
        ensure  => directory,
        owner => 'tomcat8',
        group => 'tomcat8',
    }->
    file { "${ogam::tomcat_directory}/lib/javax.mail.jar":
        ensure  => link,
        target => '/usr/share/java/gnumail.jar',
        owner => 'tomcat8',
        group => 'tomcat8',
    }->
    file { "${ogam::tomcat_directory}/lib/postgresql-jdbc4.jar":
        ensure  => link,
        target => '/usr/share/java/postgresql-jdbc4.jar',
        owner => 'tomcat8',
        group => 'tomcat8',
    }

    # Example of deployment (Integration service)
    # exec { "gradle war":
    #   path => '/usr/bin:/usr/sbin:/bin',
    #   cwd  => "${ogam::git_clone_directory}/service_integration",
    # }->
    # file { "${ogam::tomcat_directory}/conf/Catalina/localhost/OGAMIntegrationService.xml":
    #   ensure => 'file',
    #   source => "${ogam::git_clone_directory}/service_integration/config/OGAMIntegrationService.xml",
    # }->
    # tomcat::war { 'OGAMIntegrationService.war':
    #   catalina_base => $ogam::tomcat_directory,
    #   war_source    => "${ogam::git_clone_directory}/service_integration/build/libs/service_integration-4.0.0.war",
    # }
}
