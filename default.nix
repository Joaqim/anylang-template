# https://github.com/juspay/kolu/blob/34a1f4bdbcc5936c6ee7d7dc3e154b55adac0500/default.nix
{
  pkgs ? import ./nix/nixpkgs.nix { },
  commitHash ? "dev",
  pname ? "my-app",
  version ? "0.1.0",
}:
let
  src = pkgs.lib.fileset.toSource {
    root = ./my-app;
    fileset = pkgs.lib.fileset.unions [
      ./my-app/pnpm-workspace.yaml
      ./my-app/pnpm-lock.yaml
      ./my-app/common
      ./my-app/server
      ./my-app/client
    ];
  };

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit pname version src;
    hash = "sha256-0NCpb1N6+TJG1e1NUk0aDQFyQFFb0FUP+7iRZHU7pZs=";
    fetcherVersion = 3;
  };
  # Shared env vars — used by the nix build, the devShell, and the wrapper.
  # COMMIT_HASH excluded — it busts the derivation cache on every commit.
  # The build uses a placeholder; afterStamped stamps the real hash afterwards.
  env = {
  };

  commitPlaceholder = "__COMMIT_PLACEHOLDER__";
  myApp = pkgs.stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [
      pkgs.nodejs
      pkgs.pnpm
      pkgs.pnpmConfigHook
    ];
    inherit pnpmDeps;

    env = {
      COMMIT_HASH = commitPlaceholder;
    }
    // env;
    buildPhase = ''
      runHook preBuild
      pnpm --filter client build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r . $out
      rm -rf $out/client/src $out/client/node_modules
      # Fix workspace symlinks for nix store paths
      # pnpm links @my-app/common → ../../../common, but from
      # server/node_modules/@my-app/common that resolves to server/common (wrong)
      rm -f $out/server/node_modules/@my-app/common
      ln -s ../../../common $out/server/node_modules/@my-app/common
      # Same for client if node_modules were kept
      runHook postInstall
    '';
  };

  # Stamp the real commit hash
  # Only this re-runs on docs-only commits; the expensive build above is cached.
  withCommit = pkgs.runCommand "" { } ''
    cp -r ${myApp} $out
    # Make writable
    chmod -R u+w $out/client/dist
    find $out/client/dist -name '*.js' -exec \
      sed -i 's/${commitPlaceholder}/${commitHash}/g' {} +
  '';
in
{
  inherit myApp env;
  default = pkgs.writeShellApplication {
    name = "myApp";
    runtimeInputs = with pkgs; [
      nodejs
      tsx
    ];
    text = ''
      export MYAPP_CLIENT_DIST="${withCommit}/client/dist"
      exec tsx "${withCommit}/server/src/index.ts" "$@"
    '';
  };
}
