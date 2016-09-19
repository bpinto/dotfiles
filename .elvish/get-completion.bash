# Usage:
# Invoke this script with the command line, one argument per word:
#
# bash get-completion.bash pacman -S x
#
# Exits with 1 if no completer has been found.
cmd=$1 cur=${@: -1} prev=${@: -2:1}

# Get completion function.
FC=0 completer=
for a in `complete -p "$cmd"`; do
  if [ "$FC" = 1 ]; then
    completer=$a
    break
  elif [ "$a" = -F -o "$a" = -C ]; then
    FC=1
  fi
done
if [ -z "$completer" ]; then
  exit 1
fi

COMP_LINE="$*"
COMP_POINT=${#COMP_LINE}
COMP_KEY=9 COMP_TYPE=9
COMP_WORDS=("$@") COMP_CWORD=$(( $# - 1 ))
"$completer" "$cmd" "$cur" "$prev"

printf '%s\n' "${COMPREPLY[@]}"
