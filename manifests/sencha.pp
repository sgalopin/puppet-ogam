class ogam::sencha (
    String $local_scripts_directory = '/root/tmp/ogam/scripts',
    String $tmp_directory = '/var/tmp/ogam',
) {
    file { "${local_scripts_directory}/install_sencha.sh":
      ensure  => 'file',
      mode    => '0400',
      content => epp("${module_name}/install_sencha.epp", {
        tmp_directory => $tmp_directory
      }),
    }->
    exec { 'bash install_sencha.sh':
      path    => '/usr/bin:/usr/sbin:/bin',
      cwd     => $local_scripts_directory,
      unless  => 'test -f /root/bin/Sencha/Cmd/sencha',
    }
}
