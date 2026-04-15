{ dgalarza-claude-code-workflows, ... }:

{
  home.file.".claude/skills/conventional-commits" = {
    source = "${dgalarza-claude-code-workflows}/plugins/conventional-commits/skills/conventional-commits";
    recursive = true;
  };

  home.file.".pi/agent/skills/conventional-commits" = {
    source = "${dgalarza-claude-code-workflows}/plugins/conventional-commits/skills/conventional-commits";
    recursive = true;
  };
}
