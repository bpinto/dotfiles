function restart
  set -l SERVER (basename $PWD)

  pushd ..
    rake "restart:$SERVER" >/dev/null
  popd
end
