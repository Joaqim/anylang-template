# ADR-001: Typos Checking Strategy

### Status

Accepted

### Date

2026-04-09

### Context

The template includes `typos` spellchecker in the `just check` command, which runs during CI and agent workflows. This creates several issues:

1. **Agent workflow friction** — Every agent commit triggers full spellcheck, blocking on spelling errors. Fast iteration is slowed by pedantic corrections (e.g., "color" vs "colour").
2. **Wrong focus for automation** — Agents should focus on correctness, functionality, and style. Typos are human-level polish, not correctness issues.
3. **Unnecessary CI blocking** — PR merges blocked on spelling errors that don't affect code behavior.
4. **Wasted compute** — Running full LLM-powered spellcheck on every commit is inefficient.

### Decision

Move `typos` spellcheck out of `just check` and into an optional `just spellcheck` command. Use smaller, faster models for spellcheck correction in specialized CI workflows.

**Implementation:**

- `just check` runs: `fmt-check`, `zizmor`, `selfup` (no typos)
- `just spellcheck` runs: `typos` only (human opt-in)
- CI configuration:
  - Main CI: `just check` (no typos, blocks on failures)
  - Optional job: `just spellcheck` (runs on schedule or manual trigger, non-blocking)
  - PR comments: "🔍 Found 3 typos: ..." (informational, not blocking)

### Consequences

**Benefits:**

- ✅ Faster agent workflows — no spellcheck blocking iterations
- ✅ Correct focus — agents build working code, humans handle polish
- ✅ Flexible — developers run spellcheck when they want it
- ✅ CI efficiency — main CI focuses on actual issues
- ✅ Reduced compute — don't run spellcheck on every commit

**Trade-offs:**

- ⚠️ Typos may slip into main branch (but they don't break code)
- ⚠️ Requires discipline to run spellcheck before releases
- ⚠️ No automated spellcheck in default PR flow

### Options Considered

#### Option 1: Keep typos in `just check` (status quo)

- **Pros:** Automated catching of all typos, no manual step
- **Cons:** Blocks agent workflows, unnecessary friction, wasted compute
- **Effort:** zero

#### Option 2: Typos in CI as warning-only

- **Pros:** Automated detection, doesn't block PRs
- **Cons:** Still runs on every commit (waste), noise in CI logs
- **Effort:** low

#### Option 3: Move to `just spellcheck` (CHOSEN)

- **Pros:** Fast agent workflows, flexible, human-controlled, efficient
- **Cons:** Typos may slip into main, requires manual discipline
- **Effort:** low

#### Option 4: Embedded LLM in GitHub Actions for auto-fix

- **Pros:** Automated corrections, developer-friendly suggestions
- **Cons:** Complex setup, requires model hosting, overkill for simple spellcheck
- **Effort:** high

### Future Research Directions

For the `just spellcheck` implementation and CI integration, research:

**1. Smaller/faster LLMs for spellcheck:**

- **llama.cpp** with Qwen2.5-3B or Phi-3-mini (runs locally, fast)
- **Ollama** with tinyllama or phi3 models
- **groq** with fast inference for spellcheck-only endpoint
- Compare: accuracy vs speed vs cost

**2. When to run typos:**

- Run only on changed files (git diff based)
- Run only in "polish" phase, not during development
- Schedule-based (nightly/weekly) rather than per-commit

**3. Embedded LLM in GitHub Actions:**

- GitHub-hosted runners with Ollama/llama.cpp
- Pre-trained spell-correction models
- Auto-fix via commit bot (comment with suggested changes)

### References

- [typos](https://github.com/crate-ci/typos) - Source code spell checker
- [MADR 4.0](https://adr.github.io/madr/) - Architecture Decision Record format
