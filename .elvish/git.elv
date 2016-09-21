fn ok [f]{
  try $f
  except; false
  tried
}

fn not-ok [f]{
  try $f; false
  except
  tried
}

fn is-detached {
  not-ok { git symbolic-ref --short HEAD >/dev/null 2>&1 }
}

fn is-repo {
  if ok { test -d .git }; then
  else ok { git rev-parse --dir >/dev/null 2>&1 }
  fi
}

fn is-touched {
  not-ok { git status --porcelain >/dev/null 2>&1 }
}

fn branch-name {
  try
    git symbolic-ref --short HEAD 2>/dev/null
  except
    git show-ref --head -s --abbrev | head -n1
  tried
}

fn commit-count {
  splits &sep="\t" (git rev-list --count --left-right "@{upstream}...HEAD" 2>/dev/null)
}

fn ahead {
  if is-detached; then
    put detached; return
  fi

  try
    {commits-behind,commits-ahead}=(commit-count)
  except
    put none; return
  tried

  if == $commits-behind 0; then
    if == $commits-ahead 0; then
      put none
    else
      put ahead
    fi
  else
    if == $commits-ahead 0; then
      put behind
    else
      put diverged
    fi
  fi
}

