# Dev shell — shared by `nix develop` (via flake.nix) and `nix-shell`.
{
  pkgs ? import ./nix/nixpkgs.nix { },
}:
let
  packages = import ./default.nix { inherit pkgs; };
in

pkgs.mkShellNoCC {
  name = "anylang-template-shell";
  # Env vars shared with the nix build (defined once in default.nix)
  env = packages.env // {
    COMMIT_HASH = "dev";
    # Set NIX_PATH for nixd inlay hints
    #NIX_PATH = "nixpkgs=${pkgs.outPath}";
  };

  packages = with pkgs; [
    # https://github.com/NixOS/nix/issues/730#issuecomment-162323824
    bashInteractive
    findutils # xargs
    nixpkgs-fmt
    nixd
    just

    dprint
    typos
    zizmor
  ];
}
