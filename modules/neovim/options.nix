{
  globals = {
    mapleader = ",";
  };

  # ── Color ──────────────────────────────────────────────────────────
  colorscheme = "tokyonight";

  colorschemes.tokyonight = {
    enable = true;
    lazyLoad.enable = true;
    settings.style = "storm";
  };

  # Highlight over length characters
  highlightOverride.OverLength.bg = "#2E3C64";

  # ── Diagnostic ─────────────────────────────────────────────────────
  diagnostic.settings = {
    float = {
      border = "single";
      focus = false;
    };
    signs = {
      text = {
        "__rawKey__vim.diagnostic.severity.ERROR" = "";
        "__rawKey__vim.diagnostic.severity.WARN" = "";
        "__rawKey__vim.diagnostic.severity.HINT" = "";
        "__rawKey__vim.diagnostic.severity.INFO" = "";
      };
    };
    underline = true;
    update_in_insert = false; # delay update diagnostics
  };

  opts = {
    # ── Editor Configuration ─────────────────────────────────────────
    autowrite = true; # Write the contents of the file if it has been modified
    switchbuf = "useopen"; # Use already open buffer

    # ── Interface ────────────────────────────────────────────────────
    cmdheight = 2; # Height of the command bar
    cursorline = true; # Highlight current line
    foldmethod = "manual"; # Fix vim auto-complete slowness in large projects
    lazyredraw = true; # To avoid scrolling problems
    number = true; # Show line numbers
    numberwidth = 5; # Line number left margin
    scrolloff = 3; # Keep more context when scrolling off the end of a buffer (3 lines)
    showcmd = true; # Display incomplete commands
    splitbelow = true; # When on, splitting a window will put the new window below the current one
    splitright = true; # When on, splitting a window will put the new window right of the current one
    synmaxcol = 128; # Syntax coloring lines that are too long just slows down the world
    title = true; # Set window title
    updatetime = 300; # Set inactivity time to 300ms
    winborder = "single"; # Enable borders in floating windows
    winwidth = 79; # Minimal window width

    # ── Color ────────────────────────────────────────────────────────
    background = "dark";
    termguicolors = true;

    # ── Search ───────────────────────────────────────────────────────
    ignorecase = true;
    showmatch = true; # Show matching bracket when text indicator is over them
    smartcase = true; # Make searches case-sensitive only if they contain upper-case characters

    # ── Backup ───────────────────────────────────────────────────────
    backup = true; # Enable backups
    backupdir.__raw = "{ vim.fn.expand('~/.local/share/nvim/backup/') }";
    # Make vim able to edit crontab files again
    backupskip = [
      "/tmp/*"
      "/private/tmp/*"
    ];
    swapfile = false; # It's 2021, Vim.
    undofile = true; # Enable undo history
    undodir.__raw = "{ vim.fn.expand('~/.local/share/nvim/undo/') }";

    # ── Indentation ──────────────────────────────────────────────────
    expandtab = true; # Use spaces, not tabs
    tabstop = 2; # A tab is two spaces
    shiftwidth = 2; # An autoindent (with <<) is two spaces
    softtabstop = 2; # Should be the same value of shiftwidth
    shiftround = true; # Always round the indent to a multiple of 'shiftwidth'

    # ── Wildmenu ─────────────────────────────────────────────────────
    # Use emacs-style tab completion when selecting files, etc
    wildmode = [
      "longest"
      "list"
    ];

    # ── List ─────────────────────────────────────────────────────────
    list = true; # Show invisible characters

    # A tab should display as spaces
    # A trailing whitespace as "."
    # The character to show when wrap is off and the line continues beyond the screen as "…"
    listchars = {
      extends = "…";
      precedes = "…";
      tab = "  ";
      trail = "·";
    };
  };

  extraConfigLua = ''
    -- Add ctags stored on .git folder to search list
    vim.opt.tags:append(".git/tags")

    -- Wildignore
    vim.opt.wildignore:append({ ".hg", ".git", ".svn" }) -- Version control
    vim.opt.wildignore:append({ "*.orig" }) -- Merge resolution files
    vim.opt.wildignore:append({ "*.aux", "*.out", "*.toc" }) -- LaTeX intermediate files
    vim.opt.wildignore:append({ "*.bmp", "*.gif", "*.jpg", "*.jpeg", "*.png" }) -- Binary images
    vim.opt.wildignore:append({ "*.sw?" }) -- Vim swap files
    vim.opt.wildignore:append({ "*.DS_Store" }) -- OSX bullshit
    vim.opt.wildignore:append({ "*/cassettes/**/*.yml" }) -- Ruby VCR
    vim.opt.wildignore:append({ "*/tmp/**" })
    vim.opt.wildignore:append({ "*/vendor/bundle" }) -- Cached ruby gems
  '';
}
