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
# Install pre-commit hooks in .git/hooks/
pre-commit-install:
    {{ nix_shell }} pre-commit install

# Run all pre-commit hooks manually on all files
pre-commit-run:
    {{ nix_shell }} pre-commit run --all-files

# Update pre-commit hook versions to latest
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

# Spellcheck (optional, human-controlled or specialized CI)
spellcheck:
    {{ nix_shell }} typos . .github .vscode

# Run CI verification
# Override this in projects with actual CI commands
ci: check
    @echo "CI check passed"

# Update selfup to latest version and run it
selfup:
    git ls-files | xargs nix run github:kachick/selfup/v1.3.1 -- run

# Nix build
build:
    nix build

# Run the application
run:
    nix run

# Run tests (placeholder - override in projects)
# Override this in projects with actual test commands
test:
    @echo "No tests configured for this project"
