plan ogam (
  Variant[String[1], Array[String[1]]]  $nodes,
) {
  # process frontends
  run_task('ogam', $nodes, action => 'build_db')
  run_task('ogam', $nodes, action => 'build_ogamserver')
  run_task('ogam', $nodes, action => 'build_ogamdesktop')
  run_task('ogam', $nodes, action => 'build_ogamservices')
}
