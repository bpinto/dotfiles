if not set -q terminal_colors_set
  echo Setting colors
  set -U terminal_colors_set

  set -U fish_color_autosuggestion 4B5263 # the color used for autosuggestions
  set -U fish_color_cancel F44747 # the color for the '^C' indicator on a canceled command
  set -U fish_color_command green # the color for commands
  set -U fish_color_comment 5C6370 # the color used for code comments
  set -U fish_color_cwd 61AFEF # the color used for the current working directory in the default prompt
  set -U fish_color_cwd_root red
  set -U fish_color_end C678DD # the color for process separators like ';' and '&'
  set -U fish_color_error E06C75 # the color used to highlight potential errors
  set -U fish_color_escape 00A6B2 # the color used to highlight character escapes like '\n' and '\x70'
  set -U fish_color_history_current --bold
  set -U fish_color_host normal # the color used to print the current host system in some of fish default prompts
  set -U fish_color_match --background=brblue # the color used to highlight matching parenthesis
  set -U fish_color_normal E3E5E9 # the default color
  set -U fish_color_operator DC6D76 # the color for parameter expansion operators like '*' and '~'
  set -U fish_color_param ABB2BF # the color for regular command parameters
  set -U fish_color_quote 98C379 # the color for quoted blocks of text
  set -U fish_color_redirection E5C07B # the color for IO redirections
  set -U fish_color_search_match bryellow --background=brblack # used to highlight history search matches and the selected pager item (must be a background)
  set -U fish_color_selection white --bold --background=brblack # the color used when selecting text (in vi visual mode)
  set -U fish_color_status red
  set -U fish_color_user brgreen # the color used to print the current username in some of fish default prompts
  set -U fish_color_valid_path --underline
end
