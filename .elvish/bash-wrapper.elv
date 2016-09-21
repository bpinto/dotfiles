fn complete {
  try
    bash -l ~/.elvish/get-completion.bash $@ 2>/dev/null
  except
  tried
}
