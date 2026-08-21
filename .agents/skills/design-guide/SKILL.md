---
name: design-guide
description: Use when implementing Clix UI from Figma or Figma MCP, mapping colors and typography to tokens, or when choosing gaps, fixed dimensions, screen metrics, font sizes, or corner radii — without hardcoding layout or radius numbers in feature UI
---

# Design guide (Figma → Clix)

## Overview

**Single sources of truth:** `assets/colors/colors.xml` (FlutterGen → `lib/generated/colors.gen.dart` as `AppColors`) and `lib/app/core/theme/app_text_styles.dart` (`AppTextStyles`). Figma is reference only — no ad hoc palette or typography in widgets.

**Layout:** **`AppGaps.gapN`** = prebuilt **`Gap`** widgets between **`Row`/`Column`** children (only gaps declared in **`app_gaps.dart`**; add a line when needed). **`AppSize`** = **`sizeN` where `N` matches the dp value** (e.g. `size92 == 92`), plus fractional names like **`size1_5`** — declare only sizes in use in **`app_size.dart`**; no semantic names on `AppSize`. **`AppFontSize`** = `fontSize` tokens in use. **`AppBorderRadius`** = prebuilt **`BorderRadius`** / **`Radius`** in **`app_border_radius.dart`** (only what is in use; add when needed) — no raw `BorderRadius.circular(n)` in UI.

**REQUIRED companion:** **app-theme** for no gradients and barrel imports.

---

## When to use

Figma MCP, colors/types, token drift, **or** layout: gaps, fixed dimensions, screen/keyboard metrics, font sizes, **or corner radius**.

**Skip** for non-UI logic.

---

## Colors

1. **`AppColors.*`** from `lib/generated/colors.gen.dart` only (never hand-edit generated file).
2. Figma hex not in XML? Closest **semantic** token (background/surface, border/muted, accent/brand).
3. New shared color: `assets/colors/colors.xml` → **`dart run build_runner build --delete-conflicting-outputs`**.
4. No `Color(0x…)` / `Colors.*` in widgets except via tokens; opacity via `withValues(alpha: …)` or **app-theme** patterns.

---

## Typography

1. Base: **`AppTextStyles`** (`google_fonts`, Anek Latin) — **scale tokens only** (e.g. `h1`, `bodyLarge`, `headline22`); not feature-specific names.
2. **`copyWith`** belongs **in the widget** (or `app_theme.dart` / shared app widgets), e.g. `static final TextStyle _subtitle = AppTextStyles.bodyLarge.copyWith(color: …)` — **not** as getters on `AppTextStyles`.
3. No freestanding `TextStyle(...)` or raw `GoogleFonts` in feature UI.
4. **`fontSize`:** **`AppFontSize`** only — add constants in **`app_font_size.dart`** when a new size appears.
5. Add a **new field** on `AppTextStyles` only when the design needs a **new base step** (size/weight/height) that cannot start from an existing token; optional `/// Figma node …`.

---

## Gaps (`AppGaps`)

**`lib/app/core/theme/app_gaps.dart`:** **`static const Gap gapN = Gap(n)`** — use **`AppGaps.gap16`** in child lists. Add a line when a new step is needed.

---

## Sizes (`AppSize`)

**`lib/app/core/theme/app_size.dart`:** **`AppSize.sizeN == N`** (integer dp). Non-integer layout values use fractional names (**`size1_5`**, **`size19_25`**, etc.). **Do not** pre-fill a grid — add a constant when it first appears in UI. **Pure ratios** (e.g. `0.62` of width) stay as literals at the widget — not on `AppSize`. **EdgeInsets** / blur sigma / stroke width use **`AppSize`**, not raw numbers. Figma context belongs in **`///` comments** at the call site if helpful.

---

## Font sizes (`AppFontSize`)

**`app_font_size.dart`** — only sizes in use; extend when Figma adds one.

---

## Border radius (`AppBorderRadius`)

**`lib/app/core/theme/app_border_radius.dart`** — **`AppBorderRadius.borderRadiusN`** / **`AppBorderRadius.radiusN`** matching the pixel radius. **Do not** pre-fill unused values — add a **`BorderRadius`** or **`Radius`** line when a new corner value appears in UI. Use these for **`ClipRRect`**, **`BoxDecoration`**, **`OutlineInputBorder`**, **`Material`**.

---

## Quick reference

- Flex spacing → **`AppGaps.gapN`**.
- Padding, width, height, blur sigma → **`AppSize`**.
- `fontSize` → **`AppFontSize`**.
- Corners → **`AppBorderRadius`**.
- Colors → **`AppColors`** / XML + codegen.

## Common mistakes

- Raw `Gap(12)` in features → **`AppGaps.gap12`** (after adding it).
- `BorderRadius.circular(12)` → **`AppBorderRadius.borderRadius12`** (or add a named entry).
- **`AppGaps`** vs **`AppSize`** — gap widgets vs numeric layout.

---

## Files (bookmark)

`colors.xml` → `colors.gen.dart`; **`app_border_radius.dart`**, **`app_gaps.dart`**, **`app_size.dart`**, **`app_font_size.dart`**, `app_text_styles.dart`, `theme.dart` barrel.
