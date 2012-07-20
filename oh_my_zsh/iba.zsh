add-remote-jiji() {
  PROJECT=$(basename $PWD)
  git remote add 'jiji' "twer@xfwang.local:~/code/iba_2_0/$PROJECT"
}

add-remote-bogus() {
  PROJECT=$(basename $PWD)
  git remote add 'bogus' "fmobus@fmobus.local:~/everything/$PROJECT"
}

run() {
  SERVER=$(basename $PWD)
  PORT=$(cd .. &>/dev/null && exec rake -D | grep -E "Start.*$SERVER.*port: .*" | sed -E 's/.*port: ([0-9]+).*/\1/')
  (cd .. &>/dev/null && rake "stop:$SERVER" &>/dev/null)
  bundle exec rackup -p $PORT -s thin
}

run-background() {
  SERVER=$(basename $PWD)
  (cd .. &>/dev/null && rake "restart:$SERVER" &>/dev/null)
}

export RUBYOPT=-Ku
export PATH=$ORACLE_HOME:$PATH

export NLS_LANG="AMERICAN_AMERICA.UTF8"
export ORACLE_HOME=/opt/oracle/instantclient_10_2
export DYLD_LIBRARY_PATH=$ORACLE_HOME
export LD_LIBRARY_PATH=$ORACLE_HOME
export PATH=$ORACLE_HOME:$PATH

alias sqlplus='rlwrap sqlplus'

FTF_CONN="FTF/FTF@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=7521))(CONNECT_DATA=(SID=TD153)))"
alias sqlplus-ftf="sqlplus '$FTF_CONN'"

alias tunnel-crp='ssh -L 6521:10.80.3.201:1521 ess61'
alias tunnel-ftf='ssh -L 7521:10.195.1.124:1521 ess61'

