# Apple to Custom Design System Guide

Last updated: 2026-10-13
Stage: 18
Status: Working guide

## Purpose
Document how this laboratory moves from Apple-native references to custom design-system ownership without losing semantics, accessibility, or source traceability.

## Decision model
For each UI decision, ask:
1. Is this behavior already correctly owned by the platform?
2. Is the product requirement visual, semantic, behavioral, or all three?
3. Can brand expression be introduced without replacing adaptive behavior?
4. If replacement is required, what accessibility and state contracts must be re-owned?

## Ownership split

### System-owned by default
- navigation patterns
- control semantics
- focus and activation behavior
- accessibility traits
- Dynamic Type adaptation
- platform state feedback expectations

### Product-owned when justified
- brand accent direction
- emphasis hierarchy beyond default tone
- composition patterns unique to the product
- reusable component framing once semantics remain intact

## Token layering
Move ownership in this order:
1. Primitive tokens: raw spacing, radius, brand palette
2. Semantic tokens: text, surfaces, actions, borders
3. Component tokens: card, button, badge, field, composed patterns

## Translation and provenance
Before importing external values:
- record source artifact metadata,
- map source targets to token paths,
- mark confidence level,
- validate in simulator,
- preserve rejected/alternative mappings in documentation,
- and keep unresolved values provisional instead of guessing.

## Stage-based progression
- Stages 0-7: establish Apple baseline knowledge and anti-pattern awareness
- Stages 8-14: build token and component architecture
- Stages 15-17: harden accessibility, localization, and motion contracts
- Stage 18: use Apple JSON exports as an auditable source inventory for token/component mapping and fidelity ownership

## Stage 18 addendum — Apple JSON integration and fidelity ownership
Stage 18 changes the source-of-truth workflow:
- exported Apple-kit metadata becomes the inspectable inventory layer,
- selected component names are mapped to token/component destinations,
- native-first baseline composition remains the semantic control,
- branded custom-system composition remains the owned expression layer,
- and fidelity findings must be classified before changing tokens.

### Stage 18 rule
Source metadata and mapping confidence must be explicit before visual-correction changes are allowed.

### Stage 18 promotion criteria
A custom component or token mapping is promotable when:
- semantic ownership is clear,
- token usage is traceable,
- source metadata is attached,
- accessibility is preserved,
- localized/adaptive environments remain acceptable,
- and differences from Apple baseline are intentional and documented.

## Practical rule
Customize expression before customizing behavior. When behavior must be customized, document parity expectations explicitly and test them under environment stress.
