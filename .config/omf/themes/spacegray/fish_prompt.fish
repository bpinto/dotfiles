function fish_prompt
  set -l code $status

  set -l ahead    " ↑"
  set -l behind   " ↓"
  set -l diverged " ⥄ "
  set -l dirty    " ⨯"
  set -l none     " ◦"

  set_color normal
  echo -n -s "("
  echo -n -s (set_color green) (basename (prompt_pwd)) (set_color normal)
  echo -n -s ")"

  if git_is_repo
    echo -n -s " " (set_color yellow) (git_branch_name)

    if git_is_touched
      echo -n -s $dirty
    else
      echo -n -s (git_ahead $ahead $behind $diverged $none)
    end
  end

  test $code = 0; and set_color green; or set_color red
  echo -n -s ' $ ' (set_color normal)
end
