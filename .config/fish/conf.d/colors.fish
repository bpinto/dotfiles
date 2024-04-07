if not set -q terminal_colors_set
    echo Setting colors
    set -U terminal_colors_set

    # Syntax Highlighting Colors
    # https://fishshell.com/docs/current/interactive.html#syntax-highlighting-variables
    set -U fish_color_normal c0caf5
    set -U fish_color_command 7dcfff
    set -U fish_color_keyword bb9af7
    set -U fish_color_quote e0af68
    set -U fish_color_redirection c0caf5
    set -U fish_color_end ff9e64
    set -U fish_color_error f7768e
    set -U fish_color_param 9d7cd8
    set -U fish_color_comment 565f89
    set -U fish_color_selection --background=2e3c64
    set -U fish_color_search_match --background=2e3c64
    set -U fish_color_operator 9ece6a
    set -U fish_color_escape bb9af7
    set -U fish_color_autosuggestion 565f89

    # Completion Pager Colors
    # https://fishshell.com/docs/current/interactive.html#pager-color-variables
    set -U fish_pager_color_progress 565f89
    set -U fish_pager_color_prefix 7dcfff
    set -U fish_pager_color_completion c0caf5
    set -U fish_pager_color_description 565f89
    set -U fish_pager_color_selected_background --background=2e3c64
end
