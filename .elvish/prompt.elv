use git

symbol-for=[&ahead="↑" &behind="↓" &diverged="⥄ " &dirty="⨯" &none="◦"]

fn prompt {
  le:styled (tilde-abbr $pwd) 33
  if git:is-repo; then
    put ' on '; le:styled (git:branch-name) 32

    if git:is-touched; then
      put ' '$symbol-for[dirty]' '
    else
      put ' '$symbol-for[(git:ahead)]' '
    fi
  else
    put ' ❱ ' 
  fi
}

