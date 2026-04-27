# IMPORTANT: This flake intentionally has ZERO inputs.
#
# nixpkgs is imported via fetchTarball in nix/nixpkgs.nix, bypassing the
# flake input system. This is critical for `nix develop` performance.
#
# DO NOT add flake inputs (nixpkgs, flake-parts, git-hooks, etc.).
# Instead, use fetchTarball or callPackage in nix/ files.
{
  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      eachSystem =
        f:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = f (import ./nix/nixpkgs.nix { inherit system; });
          }) systems
        );

    in
    {
      formatter = eachSystem (pkgs: pkgs.nixfmt-tree);
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShellNoCC {
          # Set NIX_PATH for nixd inlay hints
          env.NIX_PATH = "nixpkgs=${nixpkgs.outPath}";

          buildInputs = (
            with pkgs;
            [
              # https://github.com/NixOS/nix/issues/730#issuecomment-162323824
              bashInteractive
              findutils # xargs
              nixfmt # nixfmt-rfc-style is now nixfmt: https://github.com/NixOS/nixpkgs/pull/425068
              nixfmt-tree
              nixd
              go-task
              npins

              dprint
              typos
              zizmor
            ]
          );
        };
      });
    };
}
