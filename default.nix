# https://github.com/juspay/kolu/blob/34a1f4bdbcc5936c6ee7d7dc3e154b55adac0500/default.nix
{
  pkgs ? import ./nix/nixpkgs.nix { },
  commitHash ? "dev",
}:
let
  # TODO;
  src = pkgs.lib.fileset.toSource {
    root = ./.;
    fileset = pkgs.lib.fileset.unions [
    ];
  };
  # Shared env vars — used by the nix build, the devShell, and the wrapper.
  # COMMIT_HASH excluded — it busts the derivation cache on every commit.
  # The build uses a placeholder; afterStamped stamps the real hash afterwards.
  env = {
  };

  commitPlaceholder = "__COMMIT_PLACEHOLDER__";
  anylangTemplate = pkgs.stdenv.mkDerivation {
    name = "anylang-template";
    inherit src;
    env = {
      COMMIT_HASH = commitPlaceholder;
    }
    // env;
    buildInputs = [ ];
    buildPhase = ''
      # TODO
    '';
  };

  # Stamp the real commit hash
  # Only this re-runs on docs-only commits; the expensive build above is cached.
  withCommit = pkgs.runCommand "" { } ''
    cp -r ${anylangTemplate} $out
    # TODO: Narrow down to relevant output files

    # Make writable
    #chmod -R u+w $out
    #find $out -name '*' -exec \
    # sed -i 's/${commitPlaceholder}/${commitHash}/g' {} +
  '';
in
{
  inherit anylangTemplate env;
  default = pkgs.writeShellApplication {
    name = "anylang-template";
    runtimeInputs = [ ];
    text = ''
      exec ${pkgs.lib.getExe anylangTemplate} "$@"
    '';
  };
}
