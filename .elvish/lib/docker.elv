use re

fn -find-main-service {
  echo abc
}

fn -parse-yaml {
  s = '[[:space:]]*'
  w = '[[:word:]]*'
  fs = (echo @|tr @ '\034')

  #echo $s
  #echo $w
  #echo $fs

  slurp < docker-compose.yml | splits "\n" (all) | each [line]{
    re:replace '^('$s'):' '${1}' $line
    #echo $line
  }
}

fn init [@command]{
  if ?(test -f docker-compose.yml) {
    -parse-yaml
  } else {
    exec (put $@command | joins ' ')
  }
}

#function parse_yaml {
#   local prefix=$2
#   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
#   sed -ne "s|^\($s\):|\1|" \
#        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
#        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
#   awk -F$fs '{
#      indent = length($1)/2;
#      vname[indent] = $2;
#      for (i in vname) {if (i > indent) {delete vname[i]}}
#      if (length($3) > 0) {
#         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
#         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
#      }
#   }'
#}
