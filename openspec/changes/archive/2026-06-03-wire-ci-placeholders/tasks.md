# Tasks: Wire CI Placeholders

## 1. Replace fmt-check placeholder

- [x] 1.1 Replace echo with `dprint check` and `nixfmt --check` on tracked nix files

## 2. Replace lint-check placeholder

- [x] 2.1 Replace echo with `typos`, `zizmor`, and `selfup --list -check`

## 3. Fix test placeholder to fail explicitly

- [x] 3.1 Replace echo with a message that exits non-zero

## 4. Verify

- [x] 4.1 Run `just ci fmt-check` and confirm it passes (or reports real errors)
- [x] 4.2 Run `just ci lint-check` and confirm it passes
- [x] 4.3 Run `just ci test` and confirm it exits non-zero
