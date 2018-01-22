class ogam::git (
    String $git_clone_directory = '/root/tmp/ogam/sources'
) {
    vcsrepo { $git_clone_directory:
        ensure   => latest,
        provider => git,
        source   => 'http://gitlab.dockerforge.ign.fr/ogam/ogam.git',
        revision => 'master',
    }
}