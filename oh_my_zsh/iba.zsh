alias remote="GO_ENVIRONMENT_NAME=bpinto headless=false SELENIUM_GRID=http://10.10.100.66:4444/wd/hub redis_host=vm100-102.sc01.thoughtworks.com bundle exec"
alias morning="rake morning"

add-remote-jiji() {
  PROJECT=$(basename $PWD)
  git remote add 'jiji' "twer@xfwang.local:~/code/iba_2_0/$PROJECT"
}

run() {
  SERVER=$(basename $PWD)
  PORT=$(cd .. &>/dev/null && exec rake -D | grep -E "Start.*$SERVER.*port: .*" | sed -E 's/.*port: ([0-9]+).*/\1/')
  (cd .. &>/dev/null && rake "stop:$SERVER" &>/dev/null)
  bundle exec rackup -p $PORT -s thin
}

export RUBYOPT=-Ku

export NLS_LANG="AMERICAN_AMERICA.UTF8"
export ORACLE_HOME=/opt/oracle/instantclient_10_2
export DYLD_LIBRARY_PATH=$ORACLE_HOME
export LD_LIBRARY_PATH=$ORACLE_HOME
export PATH=$ORACLE_HOME:$PATH
