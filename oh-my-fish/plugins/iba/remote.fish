function remote
  if test -z (netstat -an | grep 12345 | xargs echo)
    command ssh -fND 12345 root@vm101-036.sc01.thoughtworks.com
  end

  command socksify_ruby localhost 12345 $argv
end
