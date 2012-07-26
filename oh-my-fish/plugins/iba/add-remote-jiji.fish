function add-remote-jiji
  set -l PROJECT (basename $PWD)
  git remote add 'jiji' "twer@xfwang.local:~/code/iba_2_0/$PROJECT"
end
