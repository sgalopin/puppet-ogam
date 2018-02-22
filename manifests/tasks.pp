class ogam::tasks {

  file { "${ogam::local_scripts_directory}/build_db.sh":
    ensure  => 'file',
    mode    => '0400',
    content => epp("${module_name}/build_db.epp"),
  }
  file { "${ogam::local_scripts_directory}/build_ogamserver.sh":
    ensure  => 'file',
    mode    => '0400',
    content => epp("${module_name}/build_ogamserver.epp"),
  }
  file { "${ogam::local_scripts_directory}/build_ogamdesktop.sh":
    ensure  => 'file',
    mode    => '0400',
    content => epp("${module_name}/build_ogamdesktop.epp"),
  }
  file { "${ogam::local_scripts_directory}/build_ogamservices.sh":
    ensure  => 'file',
    mode    => '0400',
    content => epp("${module_name}/build_ogamservices.epp"),
  }
  file { "${ogam::local_scripts_directory}/tasks_plan.sh":
    ensure  => 'file',
    mode    => '0400',
    content => epp("${module_name}/tasks_plan.epp"),
  }
}