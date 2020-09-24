function _git_dir_folder
  test -d .git; and echo .git; or command git rev-parse --git-dir 2>/dev/null
end


function dockerize_commands
  set path (_git_dir_folder)

  if test -n "$path"; and test -f "$path/docker-compose"
    set app_name (cat "$path/docker-compose")
    command docker-compose run --rm $app_name $argv
  else
    command rake $argv
  end
end
