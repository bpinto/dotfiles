{ pkgs, ... }:

{
  plugins.snacks = {
    enable = true;

    lazyLoad.settings = {
      cmd = [ "Snacks" ];
      keys = [
        {
          __unkeyed-1 = "<leader>gi";
          mode = "n";
        }
        {
          __unkeyed-1 = "<leader>gI";
          mode = "n";
        }
        {
          __unkeyed-1 = "<leader>gp";
          mode = "n";
        }
        {
          __unkeyed-1 = "<leader>gP";
          mode = "n";
        }
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gi";
      options.desc = "GitHub Issues (open)";
      action.__raw = "function() Snacks.picker.gh_issue() end";
    }
    {
      mode = "n";
      key = "<leader>gI";
      options.desc = "GitHub Issues (all)";
      action.__raw = ''function() Snacks.picker.gh_issue({ state = "all" }) end'';
    }
    {
      mode = "n";
      key = "<leader>gp";
      options.desc = "GitHub Pull Requests (open)";
      action.__raw = "function() Snacks.picker.gh_pr() end";
    }
    {
      mode = "n";
      key = "<leader>gP";
      options.desc = "GitHub Pull Requests (all)";
      action.__raw = ''function() Snacks.picker.gh_pr({ state = "all" }) end'';
    }
  ];
}
