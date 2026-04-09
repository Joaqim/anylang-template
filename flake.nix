# IMPORTANT: This flake intentionally has ZERO inputs.
#
# nixpkgs is imported via fetchTarball in nix/nixpkgs.nix, bypassing the
# flake input system. This is critical for `nix develop` performance:
#
#   - Each flake input adds ~1.5s of fetcher-cache verification on cold
#     eval cache. Even a single nixpkgs input costs ~7s.
#   - With zero inputs, `nix develop` cold is ~2.6s, warm is ~0.3s.
#
# DO NOT add flake inputs (nixpkgs, flake-parts, git-hooks, etc.).
# Instead, use fetchTarball or callPackage in nix/ files.
{
  outputs =
    { self, ... }:
    let
      systems = [
        "x86_64-linux"
      ];
      eachSystem =
        f:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = f (import ./nix/nixpkgs.nix { inherit system; });
          }) systems
        );
      commitHash = self.shortRev or self.dirtyShortRev or "dev";
    in
    {
      formatter = eachSystem (pkgs: pkgs.nixfmt-tree);
      packages = eachSystem (
        pkgs:
        let
          all = import ./default.nix { inherit pkgs commitHash; };
        in
        removeAttrs all [ "env" ]
      );
      devShells = eachSystem (pkgs: {
        default = import ./shell.nix { inherit pkgs; };
      });
    };
}
