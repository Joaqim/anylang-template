# Prefix for commands that need a Nix devshell; empty if already inside one.

nix_shell := if env('IN_NIX_SHELL', '') != '' { '' } else { 'nix develop path:' + justfile_directory() + ' -c' }

mod ai 'agents/ai.just'
mod ci 'ci/mod.just'

# List available recipes
default:
    @just --list

# Remove all git-ignored files (node_modules, build artifacts, etc.)
clean:
    git clean -fdX

# Format all files in-place
fmt:
    {{ nix_shell }} sh -c 'dprint fmt; nixpkgs-fmt *.nix nix/**/*.nix'

# Check formatting without modifying files (used by CI)
fmt-check:
    {{ nix_shell }} sh -c 'dprint check ; typos . .github .vscode ; zizmor . ; nixpkgs-fmt --check *.nix nix/**/*.nix'
    git ls-files | xargs nix run github:kachick/selfup/v1.3.1 -- list -check

selfup:
    git ls-files | xargs nix run github:kachick/selfup/v1.3.1 -- run

# Nix build
build:
    nix build

# Run the application
run:
    nix run
