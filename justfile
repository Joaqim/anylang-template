# Root justfile for anylang-template
#
# Imports agent and CI submodules. Add project-specific recipes here.

mod ai 'agents/ai.just'
mod ci 'ci/mod.just'

nix_shell := if env('IN_NIX_SHELL', '') != '' { '' } else { 'nix develop path:' + justfile_directory() + ' -c' }
selfup := 'nix run --accept-flake-config github:kachick/selfup/v1.3.1'

# Run format, lint, and test
default: fmt lint test

# Run test and lint (CI gate)
check: test lint

# Remove all git-ignored files (node_modules, build artifacts, etc.)
clean:
    git clean -fdX

# Format all files
fmt:
    {{ nix_shell }} dprint fmt
    nix fmt

# Check formatting without modifying files
fmt-check:
    {{ nix_shell }} dprint check
    {{ nix_shell }} sh -c "git ls-files '*.nix' | xargs nixfmt --check"

# Run linters without modifying files
lint:
    {{ nix_shell }} dprint check
    {{ nix_shell }} typos . .github .vscode
    {{ nix_shell }} zizmor .
    {{ nix_shell }} sh -c "git ls-files '*.nix' | xargs nixfmt --check"
    {{ nix_shell }} sh -c "git ls-files | xargs {{ selfup }} -- list -check"

# Spellcheck
spellcheck:
    {{ nix_shell }} typos . .github .vscode

# Test suite placeholder — replace with your test runner
test:
    echo 'CHANGEME: Add tests'

# Update tool versions via selfup
selfup:
    {{ nix_shell }} sh -c "git ls-files | xargs {{ selfup }} -- run"

# Nix build
build:
    nix build

# Run the application
run:
    nix run

# Pre-commit hooks — requires pre-commit in dev shell or PATH
# TODO: add pre-commit to flake.nix buildInputs when adopting pre-commit workflow
pre-commit-install:
    {{ nix_shell }} pre-commit install

# Run all pre-commit hooks manually on all files
pre-commit-run:
    {{ nix_shell }} pre-commit run --all-files

# Update pre-commit hook versions to latest
pre-commit-update:
    {{ nix_shell }} pre-commit autoupdate
