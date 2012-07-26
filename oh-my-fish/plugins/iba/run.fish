function run
  set -l SERVER (basename $PWD)

  pushd ..
    set -l PORT (rake -D | grep -E "Start.*$SERVER.*port: .*" | sed -E 's/.*port: ([0-9]+).*/\1/')
    rake "stop:$SERVER" >/dev/null
  popd

  bundle exec rackup -p $PORT -s thin
end
