# https://github.com/kovidgoyal/kitty/blob/1bcd0c4471e2048a7f7dac0c1d1455a212e4dce4/docs/kittens/custom.rst#using-kittens-to-script-kitty-without-any-terminal-ui

def main(args):
    pass

from kittens.tui.handler import result_handler
@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    tab = boss.active_tab
    if tab is not None:
        if tab.current_layout.name == 'stack':
            tab.last_used_layout()
        else:
            tab.goto_layout('stack')
