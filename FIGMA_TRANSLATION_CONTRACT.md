# Figma Translation Contract

Last updated: 2026-10-13
Stage: 10
Status: Provisional (no inspectable Figma access)

## Purpose
Define a source-traceable contract that maps design-source intent to code token paths before external values are imported.

## Current source state
- Apple design resources are known.
- No inspectable Figma file/session/export is currently available in this workspace.
- Therefore all Stage 10 mappings are provisional and may not claim official numeric values.

## Translation schema
Each imported value must capture:
1. Source artifact metadata (file/version/date).
2. Source node identity (page/component/layer or equivalent).
3. Token destination path in code.
4. Confidence and verification status.
5. Rationale for semantic ownership.

## Provisional mapping table

| Source target | Token path | Evidence rationale | Status |
| --- | --- | --- | --- |
| Button / Primary / Container fill | `components.button.background` | Primary action emphasis from semantic actions | Provisional |
| Button / Primary / Label color | `components.button.foreground` | On-accent text readability role | Provisional |
| Card / Surface fill | `components.card.background` | Semantic primary surface | Provisional |
| Card / Border | `components.card.border` + `components.card.borderWidth` | Semantic subtle boundary + contrast resilience | Provisional |
| Badge / Pill background | `components.badge.background` | Accent surface for lightweight emphasis | Provisional |

## Verification gates
- Never tag a value as official without inspectable source evidence.
- Every external value import must include source metadata and token path.
- Unknown mappings stay provisional until evidence is attached.
- Rejected mappings must keep rationale and replacement token path.

## Promotion criteria (Provisional -> Verified)
- Inspectable source access is available.
- Node-level metadata is captured and linked.
- Mapped token is visually validated in simulator matrix.
- Accessibility/adaptation checks pass for the mapped component.
