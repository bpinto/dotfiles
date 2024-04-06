if not set -q terminal_colors_set
    echo Setting colors
    set -U terminal_colors_set

    # syntax highlighting variables
    # https://fishshell.com/docs/current/interactive.html#syntax-highlighting-variables
    set -U fish_color_normal e0def4
    set -U fish_color_command ea9a97
    set -U fish_color_keyword 9ccfd8
    set -U fish_color_quote f6c177
    set -U fish_color_redirection 3e8fb0
    set -U fish_color_end 908caa
    set -U fish_color_error eb6f92
    set -U fish_color_param e0def4
    set -U fish_color_comment 908caa
    # set -U fish_color_match --background=brblue
    set -U fish_color_selection --reverse
    # set -U fish_color_history_current --bold
    set -U fish_color_operator e0def4
    set -U fish_color_escape 3e8fb0
    set -U fish_color_autosuggestion 908caa
    set -U fish_color_cwd ea9a97
    # set -U fish_color_cwd_root red
    set -U fish_color_user f6c177
    set -U fish_color_host 9ccfd8
    set -U fish_color_host_remote c4a7e7
    set -U fish_color_cancel e0def4
    set -U fish_color_search_match --background=232136
    set -U fish_color_valid_path

    # pager color variables
    # https://fishshell.com/docs/current/interactive.html#pager-color-variables
    set -U fish_pager_color_progress ea9a97
    set -U fish_pager_color_background --background=2a273f
    set -U fish_pager_color_prefix 9ccfd8
    set -U fish_pager_color_completion 908caa
    set -U fish_pager_color_description 908caa
    set -U fish_pager_color_secondary_background
    set -U fish_pager_color_secondary_prefix
    set -U fish_pager_color_secondary_completion
    set -U fish_pager_color_secondary_description
    set -U fish_pager_color_selected_background --background=393552
    set -U fish_pager_color_selected_prefix 9ccfd8
    set -U fish_pager_color_selected_completion e0def4
    set -U fish_pager_color_selected_description e0def4
end
