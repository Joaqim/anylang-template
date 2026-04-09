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

# Pre-commit hooks
pre-commit-install:
    {{ nix_shell }} pre-commit install

pre-commit-run:
    {{ nix_shell }} pre-commit run --all-files

pre-commit-update:
    {{ nix_shell }} pre-commit autoupdate

# Format all files in-place (now uses treefmt)
fmt:
    {{ nix_shell }} treefmt

# Check formatting without modifying files (used by CI)
fmt-check:
    {{ nix_shell }} treefmt --fail-on-change

# Run all checks (typecheck, security, formatting)
check: fmt-check
    {{ nix_shell }} sh -c 'zizmor .'
    git ls-files | xargs nix run github:kachick/selfup/v1.3.1 -- list -check

# Run CI verification
# Override this in projects with actual CI commands
ci: check
    @echo "CI check passed"

selfup:
    git ls-files | xargs nix run github:kachick/selfup/v1.3.1 -- run

# Nix build
build:
    nix build

# Run the application
run:
    nix run
