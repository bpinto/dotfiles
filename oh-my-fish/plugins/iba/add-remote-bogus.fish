function add-remote-bogus
  set -l PROJECT (basename $PWD)
  git remote add 'bogus' "fmobus@fmobus.local:~/everything/$PROJECT"
end
