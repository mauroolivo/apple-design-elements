# Apple Reference Inventory

Last updated: 2026-10-13
Stage: 18
Status: Active working inventory

## Purpose
Track the Apple-origin reference sources currently used by this laboratory, the inspectability limits of those sources, and the concrete subset selected for Stage 18 JSON-driven integration.

## Primary Apple sources

### Human Interface Guidelines
- Design Principles
- Components index
- Accessibility guidance
- Typography guidance
- Color and materials guidance
- SF Symbols guidance

Evidence level: `Documented`

### Apple Design Resources
- Source family: Apple Design Resources
- Kit identity observed in export metadata: `iOS and iPadOS 27 (Community)`
- Working source type in this workspace: exported JSON metadata

Evidence level: `Observed` for export metadata, `Documented` for Apple guidance

## Stage 18 export snapshot
Derived from the local Apple-kit export metadata used during Stage 18 execution:

| Artifact | State | Notes |
| --- | --- | --- |
| `figma-export/file.json` | Inspectable | Primary source of pages, component sets, component names, and styles |
| `figma-export/styles.json` | Sparse/empty | Not sufficient alone for value extraction |
| `figma-export/components.json` | Sparse/empty | Not sufficient alone for inventory work |
| `figma-export/component_sets.json` | Sparse/empty | Not sufficient alone for inventory work |
| `figma-export/variables_local.json` | Restricted | Variable-backed numeric extraction remained partially blocked (`403`) |

Observed metadata counts from `file.json`:
- Pages: `46`
- Components: `1506`
- Component sets: `223`
- Styles: `86`

## Stage 18 selected subset
Selected for initial JSON-driven mapping because the names and node identities were inspectable in export metadata:

| Source page / family | Source node name | Source node ID | Stage 18 use |
| --- | --- | --- | --- |
| Buttons (`507:24673`) | Button | `I12740:35300;10464:33767;12740:35321` | Button background/action mapping seed |
| Buttons (`507:24673`) | Button | `I12740:35308;10464:33985` | Button label/on-accent mapping seed |
| Text Fields (`553:22762`) | Text Field | `553:23047` | Text-field surface mapping seed |
| Lists (`507:24675`) | Row | `12740:35219` | List-row spacing/padding mapping seed |
| Notifications (`507:24678`) | Banner | `I12740:23792;533:6566;5549:6259` | Banner/accent surface mapping seed |
| Segmented Controls (`507:24683`) | Segmented Control | `10460:145` | Segmented emphasis mapping seed |

## Workspace reference artifacts
- `FIGMA_TRANSLATION_CONTRACT.md`
- `FIGMA_TO_SWIFTUI_FIDELITY_CHECKLIST.md`
- `DESIGN_SYSTEM_JOURNAL.md`
- `DESIGN_TOKENS_AND_COMPONENTS.md`
- `STAGE18_APPLE_REFERENCE_SPEC.md`
- `STAGE18_FIDELITY_LOG.md`

## Evidence classification used in this lab
- `Documented`: directly stated by Apple docs/resources
- `Observed`: verified in local implementation or exported metadata
- `Inferred`: reasoned conclusion awaiting direct evidence
- `Provisional`: intentionally not promoted to verified yet

## Access and licensing notes
- Apple design resources are reference inputs for learning and implementation guidance.
- Do not claim redistributable ownership of Apple-authored design-resource content.
- Export metadata is useful for provenance and mapping even when exact variable values are unavailable.
- Numeric value claims must remain provisional when variable-backed extraction is blocked.

## Current rule
Update this inventory before changing Stage 18 mappings, token destinations, or fidelity judgments so reference provenance stays explicit.
