class ogam::git {

    file_line { 'gitlab':
      ensure => present,
      path   => '/etc/hosts',
      line   => '192.30.253.112 gitlab.dockerforge.ign.fr',
    }->
    vcsrepo { $ogam::git_clone_directory:
        ensure   => latest,
        provider => git,
        source   => 'https://github.com/IGNF/ogam.git',
        revision => 'master',
    }
}