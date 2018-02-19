class ogam::sencha {

    file { "${ogam::local_scripts_directory}/install_sencha.sh":
      ensure  => 'file',
      mode    => '0400',
      content => epp("${module_name}/install_sencha.epp"),
    }->
    exec { 'bash install_sencha.sh':
      path    => '/usr/bin:/usr/sbin:/bin',
      cwd     => $ogam::local_scripts_directory,
      unless  => 'test -f /root/bin/Sencha/Cmd/sencha',
    }
}
