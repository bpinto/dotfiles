function wifi {
  if [[ -n $(airport -I | grep "state: init" 2>/dev/null) ]]; then
    if [[ -n $(airport -s | grep "linksys" 2>/dev/null) ]]; then
      (exec networksetup -setairportnetwork en1 linksys 2>/dev/null)
    fi
  fi
}
