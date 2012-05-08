alias remote="GO_ENVIRONMENT_NAME=bpinto headless=false SELENIUM_GRID=http://10.10.100.66:4444/wd/hub redis_host=vm100-102.sc01.thoughtworks.com bundle exec"
alias morning="rake morning"

run() {
  SERVER=$(basename $PWD)
  PORT=$(cd .. &>/dev/null && exec rake -D | grep -E "Start.*$SERVER.*port: .*" | sed -E 's/.*port: ([0-9]+).*/\1/')
  (cd .. &>/dev/null && rake "stop:$SERVER" &>/dev/null)
  bundle exec rackup -p $PORT -s thin
}
