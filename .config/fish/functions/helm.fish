function helm
  set context (kubectl config current-context)

  if test "$context" = "orbstack"
    command helm $argv
  else
    echo "Error: Current context is not allowed: $context"
    return 1
  end
end
