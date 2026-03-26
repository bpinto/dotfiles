# React skills for Pi agent (from vercel-labs/agent-skills).
#
# Fetches the agent-skills repository and symlinks selected skills
# into ~/.pi/agent/skills/. The source is pinned to a specific commit
# in flake.nix. To upgrade, update the commit SHA there and run
# `nix flake lock`.
{ vercel-labs-agent-skills, ... }:

let
  # Skills to enable from the vercel-labs/agent-skills repository.
  # Map repo source directories (src) to desired target names (dst) in
  # ~/.pi/agent/skills so we can keep a vercel- prefix locally while
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

  mkSkillEntry = skill: {
    name = ".pi/agent/skills/${skill.dst}";
    value = {
      source = "${vercel-labs-agent-skills}/skills/${skill.src}";
      recursive = true;
    };
  };
in
{
  home.file = builtins.listToAttrs (map mkSkillEntry enabledSkills);
}
