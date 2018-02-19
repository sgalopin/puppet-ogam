class ogam::gradle {

    file { "${ogam::local_scripts_directory}/install_gradle.sh":
      ensure  => 'file',
      content => epp("${module_name}/install_gradle.epp"),
      mode    => '0644',
    }->
    exec { 'bash install_sencha.sh':
      path    => '/usr/bin:/usr/sbin:/bin',
      cwd     => $ogam::local_scripts_directory,
      unless   	=> 'sencha which',
    }
}