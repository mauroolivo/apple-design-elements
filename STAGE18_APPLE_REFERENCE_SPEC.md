# Stage 18 Apple Reference Spec

Last updated: 2026-10-14
Stage: 18
Status: Provisional, metadata-inspectable

## Purpose
Define a traceable Stage 18 execution spec that turns Apple design-resource export metadata into actionable, auditable mapping inputs for the custom design system.

## Scope
- Source inventory from Apple export metadata.
- Seed mapping from source targets to token/component destinations.
- Native baseline specimen expectations.
- Branded variant specimen expectations.
- Fidelity classification and promotion gates.

## Source Inputs
- Expected export root: `figma-export/`
- Primary source artifact: `figma-export/file.json`
- Supporting source artifacts:
  - `figma-export/styles.json`
  - `figma-export/components.json`
  - `figma-export/component_sets.json`
  - `figma-export/variables_local.json` (currently partially blocked in prior runs)

## Stage 18 Five-Step Workflow
1. **JSON inventory**
   - Capture source artifact name, date, and snapshot notes.
   - Record page/component/component-set/style counts where available.
   - Record blocked extraction paths explicitly.

2. **Token/component mapping**
   - Map source target and node identity to destination token path.
   - Add rationale for semantic ownership.
   - Assign confidence status (`Provisional` or `Verified`).

3. **Native baseline composition**
   - Build baseline specimen with native controls and semantic typography.
   - Preserve accessibility traits, focus behavior, and disabled states.
   - Treat baseline as behavior contract control.

4. **Branded custom-system composition**
   - Apply owned expression via tokenized layers.
   - Keep behavior parity with baseline unless explicitly justified.
   - Document intended visual deltas.

5. **Fidelity log and correction plan**
   - Measure and classify each delta.
   - Assign owner and fix plan.
   - Block promotion while unresolved critical deltas remain.

## Mapping Seeds (Initial)

| Source target | Source node ID | Destination token path | Rationale | Status |
| --- | --- | --- | --- | --- |
| Button / Primary / Container fill | `I12740:35300;10464:33767;12740:35321` | `components.button.background` | Primary action emphasis | Provisional |
| Button / Primary / Label color | `I12740:35308;10464:33985` | `components.button.foreground` | On-accent readability role | Provisional |
| Text Field / Surface | `553:23047` | `semantics.surfaces.primary` | Text-input surface baseline | Provisional |
| List Row / Spacing container | `12740:35219` | `components.card.padding` | Shared row/card spacing contract | Provisional |
| Notification Banner / Accent surface | `I12740:23792;533:6566;5549:6259` | `semantics.surfaces.accent` | Notification emphasis semantics | Provisional |
| Segmented Control / Active emphasis | `10460:145` | `semantics.actions.primary` | Active selection emphasis | Provisional |

## Native Baseline Specimen Contract
- Use platform-native controls and interactions.
- Keep semantic text styles and adaptive system colors.
- Do not override behavior for visual preference only.
- Verify readability and control states under:
  - Light and Dark mode
  - Standard and Increased Contrast
  - Default and Accessibility Dynamic Type
  - LTR and RTL

## Branded Variant Contract
- Brand expression applies at token layer first.
- Component APIs remain semantic and role-based.
- Any behavior divergence must include explicit parity notes.
- Variants must remain testable against baseline scenarios.

## Promotion Gates (Provisional -> Verified)
A mapping can move to `Verified` when all are true:
- Source metadata is attached and inspectable.
- Node identity is recorded.
- Destination path is stable and in-use.
- Simulator checks pass for accessibility/adaptation.
- Remaining deltas are classified and accepted.

## Stage 18 Output Artifacts
- `STAGE18_APPLE_REFERENCE_SPEC.md` (this file)
- `STAGE18_FIDELITY_LOG.md`
- Updated mapping table references in `FIGMA_TRANSLATION_CONTRACT.md` as confidence changes

## Open Risks
- Variable-level extraction gaps may keep some values provisional.
- Visual parity without behavior parity is not promotable.
- Missing source metadata invalidates claims of verified fidelity.
