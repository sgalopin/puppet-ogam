class ogam::git {

    file_line { 'gitlab':
      ensure => present,
      path   => '/etc/hosts',
      line   => '172.28.99.2 gitlab.dockerforge.ign.fr',
    }->
    vcsrepo { $ogam::git_clone_directory:
        ensure   => latest,
        provider => git,
        source   => 'http://gitlab.dockerforge.ign.fr/ogam/ogam.git',
        revision => 'master',
    }
}