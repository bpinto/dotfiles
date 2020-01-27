##############################################################################
# Util functions
##############################################################################

fn null-out [f]{
  { $f 2>&- > /dev/null }
}

fn has-failed [p]{
  eq (bool ?(null-out $p)) $false
}

fn is-okay [p]{
  eq (bool ?(null-out $p)) $true
}

##############################################################################
# Git functions
##############################################################################

fn git-branch {
  try {
    git symbolic-ref --short HEAD 2>/dev/null
  } except e {
    git show-ref --head -s --abbrev | head -n1
  }
}

fn git-commit-count {
  splits "\t" (git rev-list --count --left-right "@{upstream}...HEAD" 2>/dev/null)
}

fn git-is-detached {
  has-failed { git symbolic-ref --short HEAD }
}

fn git-is-dirty {
  has-failed { git diff-index --quiet HEAD }
}

fn git-is-repo {
  or (is-okay { test -d .git }) (is-okay { git-branch })
}

fn git-status-string {
  if (git-is-detached) {
    put none; return
  }

  try {
    {commits-behind,commits-ahead}=(git-commit-count)

    if (eq $commits-behind 0) {
      if (eq $commits-ahead 0) {
        put none
      } else {
        put ahead
      }
    } else {
      if (eq $commits-ahead 0) {
        put behind
      } else {
        put diverged
      }
    }
  } except e {
    put none
  }
}

##############################################################################
# Theme
##############################################################################

symbol-for=[&ahead='⇡' &behind='⇣' &diverged='⥄ ' &dirty='⨯' &none='◦']

fn prompt {
  styled (tilde-abbr $pwd) yellow

  if (git-is-repo) {
    put ' '(git-branch)

    if (git-is-dirty) {
      styled ' '$symbol-for[dirty] blue
    } else {
      styled ' '$symbol-for[(git-status-string)] blue
    }
  }

  put ' ❱ '
}
