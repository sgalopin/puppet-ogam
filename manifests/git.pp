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
        revision => 'develop',
    }->
    # Installation of git lfs
    exec { [ "wget -O git-lfs.deb https://packagecloud.io/github/git-lfs/packages/debian/jessie/git-lfs_2.4.0_amd64.deb/download 2>&1",
             "dpkg -i git-lfs.deb" ] :
        path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        cwd     => $ogam::tmp_directory,
        unless  => "test -f /usr/bin/git-lfs",
    }->
    # https://tickets.puppetlabs.com/browse/MODULES-4442
    exec { 'git lfs fetch --all':
        path    => '/usr/bin:/usr/sbin:/bin',
        cwd     => $ogam::git_clone_directory,
  	}
}