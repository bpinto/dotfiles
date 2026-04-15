{ vercel-labs-agent-skills, ... }:

let
  # Skills to enable from the vercel-labs/agent-skills repository.
  # Map repo source directories (src) to desired target names (dst) while
  # the upstream repo uses prefix-less directories.
  enabledSkills = [
    {
      src = "composition-patterns";
      dst = "vercel-composition-patterns";
    }
    {
      src = "react-best-practices";
      dst = "vercel-react-best-practices";
    }
    {
      src = "web-design-guidelines";
      dst = "web-design-guidelines";
    }
  ];

  mkSkillEntries = skill: [
    {
      name = ".claude/skills/${skill.dst}";
      value = {
        source = "${vercel-labs-agent-skills}/skills/${skill.src}";
        recursive = true;
      };
    }
    {
      name = ".pi/agent/skills/${skill.dst}";
      value = {
        source = "${vercel-labs-agent-skills}/skills/${skill.src}";
        recursive = true;
      };
    }
  ];
in
{
  home.file = builtins.listToAttrs (builtins.concatMap mkSkillEntries enabledSkills);
}
