# Figma Translation Contract

Last updated: 2026-10-13
Stage: 18
Status: Provisional, metadata-inspectable

## Purpose
Define a source-traceable contract that maps Apple design-resource export metadata to token/component destinations before values are promoted as verified implementation inputs.

## Current source state
- Apple design resources are known and exported metadata is available in this workspace.
- `figma-export/file.json` is inspectable and provides page names, component names, component-set names, style names, and node identities.
- `styles.json`, `components.json`, and `component_sets.json` are too sparse to serve as the primary integration input by themselves.
- `variables_local.json` remained partially blocked (`403`), so exact variable-backed numeric values are still incomplete.
- Therefore Stage 18 mappings are traceable and actionable, but many remain `Provisional` rather than `Verified`.

## Translation schema
Each imported value must capture:
1. Source artifact metadata (file/version/date).
2. Source node identity (page/component/layer or equivalent).
3. Token destination path in code.
4. Confidence and verification status.
5. Rationale for semantic ownership.
6. Notes about blocked or ambiguous value extraction.

## Stage 18 mapping seeds

| Source target | Source node ID | Token path | Evidence rationale | Status |
| --- | --- | --- | --- | --- |
| Button / Primary / Container fill | `I12740:35300;10464:33767;12740:35321` | `components.button.background` | Button family visible in export metadata; mapped to primary action emphasis | Provisional |
| Button / Primary / Label color | `I12740:35308;10464:33985` | `components.button.foreground` | On-accent readability role used by `DSButton` | Provisional |
| Text Field / Surface | `553:23047` | `semantics.surfaces.primary` | Text-field component set is inspectable by name and node ID | Provisional |
| List Row / Spacing container | `12740:35219` | `components.card.padding` | Row spacing currently inferred to shared list/card spacing contract | Provisional |
| Notification Banner / Accent surface | `I12740:23792;533:6566;5549:6259` | `semantics.surfaces.accent` | Banner family visible in notifications export metadata | Provisional |
| Segmented Control / Active emphasis | `10460:145` | `semantics.actions.primary` | Active segment emphasis mapped to shared action-primary semantics | Provisional |

## Verification gates
- Never tag a value as official without inspectable source evidence.
- Every external value import must include source metadata and token path.
- Unknown mappings stay provisional until evidence is attached.
- Rejected mappings must keep rationale and replacement token path.
- Blocked variable extraction must be recorded explicitly rather than hidden.

## Promotion criteria (Provisional -> Verified)
- Inspectable source access is available.
- Node-level metadata is captured and linked.
- Mapped token is validated in the simulator matrix.
- Accessibility/adaptation checks pass for the mapped component.
- Any remaining discrepancy is classified as bug, adaptation, customization, or unresolved reference question.
