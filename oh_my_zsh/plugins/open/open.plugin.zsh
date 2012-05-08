open() {
  PORT=$(echo "$1" | grep -E "^[0-9]{4,}$")
  URL=$(echo "$1" | grep -v 'http' | grep -E ".*\.com.*")

  if [[ -n $PORT ]]; then
    /usr/bin/open "http://localhost:$PORT/"
  elif [[ -n $URL ]]; then
    /usr/bin/open "http://$URL/"
  else
    /usr/bin/open "$1"
  fi
}
