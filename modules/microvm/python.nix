# Python development module for microVMs.
#
# Uses nix-ld + uv instead of nixpkgs Python packaging. This lets uv
# download its own Python interpreter and wheels (including native
# extensions) and nix-ld provides the dynamic linker so they just work.
#
# Usage (inside the VM):
#   1. cd into your project directory
#   2. uv venv # create a virtual environment
#   3. uv pip install -r requirements.txt  # or uv sync if using pyproject.toml
#
# Then either run commands through uv:
#   uv run python <script.py>
#   uv run pytest
#
# Or set up direnv to auto-activate the venv permanently:
#   echo 'source .venv/bin/activate' | save .envrc; direnv allow
#   python <script.py> # venv activates on cd, no prefix needed
#
# If a native wheel fails at runtime with a missing .so, find what's needed:
#   find .venv/ -type f -name "*.so" | xargs ldd | grep "not found" | sort | uniq
# Then add the corresponding nixpkgs library to `python.nativeLibraries`.
#
# See: https://crescentro.se/posts/python-nixos/
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.python = {
    # Here is where you will add all the libraries required by your native modules
    # You can use the following one-liner to find out which ones you need.
    # `find .venv/ -type f -name "*.so" | xargs ldd | grep "not found" | sort | uniq`
    nativeLibraries = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional native libraries to expose via NIX_LD_LIBRARY_PATH for Python wheels.";
      example = lib.literalExpression "[ pkgs.postgresql ]";
    };
  };

  config = {
    # Let nix-ld provide a dynamic linker so uv-managed Python and native
    # wheels (numpy, grpcio, etc.) can find shared libraries.
    programs.nix-ld.enable = true;

    environment.systemPackages = [ pkgs.uv ];

    programs.nix-ld.libraries =
      [
        pkgs.stdenv.cc.cc # libstdc++
      ]
      ++ config.python.nativeLibraries;
  };
}
