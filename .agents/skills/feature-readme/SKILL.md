---
name: feature-readme
description: "Each lib/features/<name>/ needs a short README.md: summary, main files, and a Flow chart section with ASCII (always visible) plus Mermaid (GitHub/IDEs). Use when adding or finishing a feature, or when asked for feature docs."
---

# Feature README (mandatory per feature)

## When to use

- After scaffolding a new feature under `lib/features/<feature_name>/`.
- When completing work on a feature (together with `.agents/skills/post-feature-checklist/SKILL.md`).
- Whenever routes, blocs, or public APIs of a feature change materially.

## Location

```
lib/features/<feature_name>/README.md
```

One README **per feature folder** — not one monolithic doc for the whole app.

## Required sections (keep it readable)

Write for a developer who skims in **under two minutes**. Short sentences, few tables.

1. **Title + one paragraph** — what this feature does in plain language.
2. **What lives here** — bullet list of main classes/screens (names only, one line each).
3. **Files** — short bullet list of important paths (avoid huge ASCII trees).
4. **`## Flow chart`** (required) — how data/navigation flows through this feature. Include **both**:
   - **ASCII** — a simple diagram in a fenced ` ``` ` block using `│`, `▼`, `──`, so it is readable **everywhere** (editors that do not render Mermaid).
   - **Mermaid** — one `flowchart LR` or `flowchart TD` with **≤ 8 nodes**, under a **Mermaid** subheading, in a ` ```mermaid ` fence. Renders on GitHub and many IDEs.
5. **Extra** — only if needed: platform notes (e.g. Android fork), link to `.agents/features/feature_*.md`.

Avoid long tables, many subgraphs, and a second Mermaid chart unless the feature is unusually large.

## Flow chart content

- Show real names: screens, routes, blocs, key services — match the codebase.
- Prefer top-down (`TD`) or left-right (`LR`) to match the mental model (user flow vs dependency flow).
- If the feature is tiny (one screen, no navigation), the ASCII diagram can be 3–4 lines; still include a minimal Mermaid equivalent.

## Mermaid rules

- One **`flowchart`** only (unless the feature clearly needs a tiny second diagram — rare).
- **≤ 8 nodes** when possible. No `subgraph` unless it really helps.
- Valid Mermaid: test in GitHub preview or [mermaid.live](https://mermaid.live) if unsure.

## Barrel and deep imports

- README should list **public entry points** (`<feature>.dart` exports). Do not encourage deep imports in prose; align with `.agents/skills/feature-architecture/SKILL.md`.

## Consistency

- Naming matches **feature folder name** (`snake_case` folder, `` `code` `` names in backticks in README).
- When a feature has **no** `data/` or `domain/` yet, say so in one line so the doc stays honest.

## Checklist (before merging)

- [ ] `lib/features/<name>/README.md` exists.
- [ ] **`## Flow chart`** section is present with **ASCII** + **Mermaid** blocks.
- [ ] Mermaid block is valid (renders on GitHub or mermaid.live).
- [ ] File names and behaviour match the real code.
- [ ] `post-feature-checklist` Phase 11 satisfied for documentation.
