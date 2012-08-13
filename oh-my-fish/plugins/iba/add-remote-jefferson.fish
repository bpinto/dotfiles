function add-remote-jefferson
  set -l PROJECT (basename $PWD)
  git remote add 'jefferson' "jefferson@jeffersongirao.local:~/Projects/iba/$PROJECT"
end
