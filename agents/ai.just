# Run recipes from project root, not agents/
set working-directory := '..'

# Enter nix develop only when not already inside it — mirrors the root
# justfile's pattern.
nix_shell := if env('IN_NIX_SHELL', '') != '' { '' } else { 'nix develop --accept-flake-config -c' }

# APM command — uses uvx to run apm-cli without a global install.
# Override APM_CMD if you have apm installed another way.
apm_cmd := env('APM_CMD', nix_shell + ' uvx --from apm-cli apm')

# Target runtimes for `apm install`. When empty (the default), apm reads
# targets from `apm.yml`. Set APM_TARGETS to override (e.g.,
# "claude,codex,opencode").
apm_targets := env('APM_TARGETS', '')

# Target runtimes for `apm compile`. When empty (the default), the compile
# step is skipped. Set APM_COMPILE_TARGETS when you add Codex or OpenCode
# to `apm.yml` (e.g., "codex,opencode").
apm_compile_targets := env('APM_COMPILE_TARGETS', '')

# Install native APM integrations.
#
# Without APM_TARGETS, apm reads the target list from `apm.yml`. With
# APM_TARGETS set, the env var overrides `apm.yml`.
apm-install:
    {{ if apm_targets == '' { apm_cmd + ' install' } else { apm_cmd + ' install --target ' + apm_targets } }}

# Compile the shared instruction file for runtimes that read `AGENTS.md`.
#
# Claude reads `.claude/` natively, so compile is only needed for other
# targets. Skipped when APM_COMPILE_TARGETS is empty.
apm-compile:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "{{ apm_compile_targets }}" ]; then
        {{ apm_cmd }} compile --target {{ apm_compile_targets }}
    fi

# Refresh all APM-managed artifacts for the configured targets.
apm: apm-install apm-compile

# Advance locked APM dependencies to latest refs (all, or specific packages)
apm-update *packages:
    {{ if apm_targets == '' { apm_cmd + ' deps update' } else { apm_cmd + ' deps update --target ' + apm_targets } }} {{ packages }}
    {{ just_executable() }} ai apm

# Audit APM packages for security issues (Unicode, lockfile consistency)
apm-audit:
    {{ apm_cmd }} audit --ci

# Verify vendored .claude/ matches .apm/ sources + security audit
apm-sync: apm apm-audit
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "$(git status --porcelain .claude/)" ]; then
        echo "ERROR: .claude/ out of sync with .apm/ — run: just ai::apm"
        git status .claude/
        exit 1
    fi

# Install APM config and launch coding agent (AI_AGENT overrides default)
[default]
agent *args: apm
    {{ env('AI_AGENT', 'claude') }} {{ args }}
