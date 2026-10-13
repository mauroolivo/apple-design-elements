# Design Tokens and Components

Last updated: 2026-10-13
Stage: 10
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
