function add-remote-halisson
  set -l PROJECT (basename $PWD)
  git remote add 'halisson' "hvitor@hvitor-2.local:~/iba/$PROJECT"
end
