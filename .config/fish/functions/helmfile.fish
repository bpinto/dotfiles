function helmfile
  set context (kubectl config current-context)

  if test "$context" = "orbstack"
    command helmfile $argv
  else
    echo "Error: Current context is not allowed: $context"
    return 1
  end
end
