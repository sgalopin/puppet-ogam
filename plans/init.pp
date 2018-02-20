plan ogam (
  Enum[development, production] $environment,
  Variant[String[1], Array[String[1]]]  $nodes,
) {
  # process frontends
  run_task('ogam', $nodes, action => 'build_db', environment => $environment)
  run_task('ogam', $nodes, action => 'build_ogamserver', environment =>  $environment)
  run_task('ogam', $nodes, action => 'build_ogamdesktop', environment =>  $environment)
  run_task('ogam', $nodes, action => 'build_ogamservices', environment =>  $environment)
}