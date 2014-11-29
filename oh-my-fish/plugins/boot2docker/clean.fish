function clean
  if test -f fig.yml
    set fig_containers_ids (fig ps -q | cut -c-12 | xargs echo | sed 's/ /\\\|/g')

    docker rm (docker ps -a -q | grep -v $fig_containers_ids)
  else
    docker rm (docker ps -a -q)
  end
end
