# Design Tokens and Components

Last updated: 2026-10-13
Stage: 17
Status: Draft v0

## Purpose
Capture the laboratory's current token taxonomy, naming direction, and component contract boundaries as Stage 8 introduces typed token modeling.

## Token taxonomy

### Primitive tokens
Raw values with no product intent beyond measurement or source color identity.

Current examples:
- `DSPrimitiveSpacing`
- `DSPrimitiveRadius`
- `DSPrimitiveBorder`
- `DSPrimitiveBrandPalette`

### Semantic tokens
Intent-bearing values that describe what UI means, not where the raw value came from.

Current examples:
- `DSSemanticText.primary`
- `DSSemanticText.muted`
- `DSSemanticSurfaces.primary`
- `DSSemanticSurfaces.accent`
- `DSSemanticActions.primary`
- `DSSemanticBorders.subtle`

### Component tokens
Local decisions that adapt semantic tokens for a particular reusable component contract.

Current examples:
- `DSCardComponentTokens`
- `DSButtonComponentTokens`
- `DSBadgeComponentTokens`

## Current modeling decision
- Keep token modeling in the app target for now.
- Use small typed structs instead of a giant theme object.
- Allow semantic tokens to derive from system-owned behavior where appropriate:
  - `Color.primary`
  - `Color.secondary`
  - `UIColor.secondarySystemBackground`
  - `UIColor.separator`
- Allow brand decisions to flow through one narrow entry point:
  - `DSBrandDecision` -> `DSTokenBundle.make(for:)`

## Mapping example

| Layer | Example | Ownership rationale |
| --- | --- | --- |
| Primitive | `brand.accent` | Raw brand color choice |
| Semantic | `actions.primary` | Product intent: primary action emphasis |
| Component | `button.background` | Local decision for `DSButton` visual contract |

## Current public API direction
Not implemented as public API yet, but the lab is converging on these naming targets:
- Foundations
  - `DSColorRole`
  - `DSTextRole`
  - `DSSpacing`
- Components
  - `DSButton(role:size:state:)`
  - `DSField(state:)`
  - `DSCard(style:)`

## Stage 8 rule
A reusable component should prefer semantic/component tokens over direct raw values. Raw values remain acceptable only when the scope is local, explicit, and intentionally non-shared.

## Next-stage considerations
- Stage 12+: turn stable tokenized specimens into reusable component APIs

## Stage 9 - Theme resolution and propagation
- Add `DSThemeInput` as a runtime boundary (`brandDecision`, `colorScheme`, `colorSchemeContrast`, `dynamicTypeSize`).
- Resolve one `DSTokenBundle` from that boundary and inject it via `EnvironmentValues.dsTokens`.
- Consume tokens in leaf components with `@Environment(\.dsTokens)` to reduce API coupling and manual threading.
- Keep anti-pattern reference: manually passing `tokenBundle` through non-owning layers (prop drilling).

## Stage 10 - Translation contract and provenance
- Add `FIGMA_TRANSLATION_CONTRACT.md` as the audit artifact for source-to-token mapping.
- Every mapping records source target, token path, evidence rationale, and status (`Provisional` or `Verified`).
- Promote mappings to `Verified` only after inspectable source metadata and simulator/accessibility checks are attached.

## Stage 11 - Fidelity validation ownership
- Add `FIGMA_TO_SWIFTUI_FIDELITY_CHECKLIST.md` as the baseline validation protocol.
- Validate component-token geometry contracts (padding, radius, border, spacing) under fixed environment assumptions.
- Keep mismatch experiments explicit (1-3 pt deltas) and fix at token/component source, not per-screen offsets.
- Use discrepancy classification before promoting provisional mappings to verified values.

## Stage 12 - Component API implementation
- Implement `DSButton` as a typed semantic API (`role`, `size`, `state`) instead of independent booleans.
- Keep visual resolution in one style layer so pressed/disabled/loading behavior remains consistent.
- Consume token bundle via environment at component level and keep theming at subtree boundary.
- Treat loading/disabled as explicit state, not incidental modifiers spread across screens.

## Stage 13 - Forms and interactive controls
- Add `DSField` as a reusable form control that keeps editing semantics native while styling via tokenized surfaces and borders.
- Model validation states explicitly (`normal`, `focused`, `disabled`, `error`) so helper/error rendering remains deterministic.
- Preserve focus and keyboard behavior via SwiftUI focus APIs rather than custom gesture plumbing.
- Group controls and action affordances into a card-level form pattern to clarify ownership and hierarchy.

## Stage 14 - Composed component ownership
- Add composed primitives like cards, rows, section headers, status badges, and feedback banners as reusable patterns.
- Keep layout choices close to the consumer screen while reusable parts own their local token mapping.
- Use a shared surface/spacing system so composed components stay visually consistent across contexts.
- Compare a semantic-token composition against a duplicated-number composition to reveal maintenance drift.

## Stage 15 - Accessibility contract ownership
- Add an accessibility guarantee matrix to component evaluation (VoiceOver semantics, non-color meaning, touch-target comfort).
- Treat accessibility-related component state as contract data, not ad-hoc view-level overrides.
- Validate accessibility assumptions against active environment signals (Dynamic Type, contrast, layout direction, reduce-motion/transparency, differentiate-without-color).
- Block promotion of reusable variants when any accessibility guarantee fails, even if visuals appear acceptable.

## Stage 16 - Localization and directionality ownership
- Add locale and directionality stress checks to reusable component acceptance criteria.
- Prefer semantic directional symbols and adaptive text containers over fixed-direction visual assumptions.
- Validate long translated strings and pseudo-localized copies against component layout contracts before promotion.
- Treat truncation-related meaning loss as a design-system bug, not a copywriting issue.

## Stage 17 - Motion and feedback-state ownership
- Add interaction-state timing rules to component contracts (acknowledge, in-progress, success/failure, interrupted).
- Respect reduced-motion preferences when transitioning between feedback states.
- Prevent duplicate or stacked banners/spinners that increase cognitive load and blur state transitions.
- Treat interruption handling as a first-class reusable behavior contract, not screen-specific glue logic.

