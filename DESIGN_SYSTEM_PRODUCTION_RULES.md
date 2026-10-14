# Design System Production Rules

Last updated: 2026-10-14
Scope: `apple-design-elements` learning lab -> production-ready operating rules

## Purpose
Define non-negotiable rules for promoting design-system decisions from experiment to production.

## 1) Ownership and Boundaries
- Keep semantic ownership explicit: primitive -> semantic -> component.
- Avoid API growth until repeated usage pressure is demonstrated.
- Promote only stable, role-based APIs; avoid boolean explosion.

## 2) Source Traceability
- Every imported external design value must include source metadata.
- Mapping must include source target, node identity, destination token path, and confidence.
- Unknown or incomplete mappings remain `Provisional`.

## 3) Behavior Before Styling
- Preserve native behavior contracts by default.
- Customize visual expression before customizing behavior.
- Any behavior divergence requires explicit parity expectations and tests.

## 4) Accessibility Is Release-Blocking
- Required: semantic labels/hints, non-color cues, and adequate target sizes.
- Required checks: Dynamic Type, contrast, reduce motion/transparency, RTL.
- Regressions in accessibility guarantees block promotion.

## 5) Localization and Adaptation
- Components must survive long/expanded strings and pseudo-localized stress text.
- Directional semantics must support RTL without manual per-screen hacks.
- Fixed-size text and fixed-width layouts are anti-patterns unless justified.

## 6) Fidelity Classification Rule
- Never patch visuals without classifying deltas first:
  - Bug
  - Adaptation
  - Customization
  - Unresolved reference question
- Record owner and fix path for every Major/Blocker delta.

## 7) Theme and Token Resolution
- Resolve tokens at the theme boundary; inject via environment.
- Prefer semantic colors/materials over fixed values.
- Keep component internals token-driven; avoid magic numbers.

## 8) Promotion Criteria
A component/token may be promoted when all are true:
- Semantic ownership is clear.
- Source mapping is traceable.
- Accessibility/adaptation checks pass.
- Fidelity deltas are classified and accepted.
- API remains stable and understandable.

## 9) Required Artifacts per Stage 18 Completion
- `FIGMA_TRANSLATION_CONTRACT.md`
- `STAGE18_APPLE_REFERENCE_SPEC.md`
- `STAGE18_FIDELITY_LOG.md`
- `DESIGN_SYSTEM_JOURNAL.md` continuation entry with decision and verification summary

## 10) Practical Default Rule
If uncertain, choose the option that keeps platform semantics intact, traceability explicit, and future maintenance cheaper.
