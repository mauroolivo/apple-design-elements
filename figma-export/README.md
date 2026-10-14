# figma-export

This folder is the expected local home for inspectable Apple design-resource export artifacts used by Stage 18.

## Expected Files
- `file.json` (primary metadata inventory)
- `styles.json`
- `components.json`
- `component_sets.json`
- `variables_local.json` (may be partially unavailable depending on access)

## Current Workspace Note
At the time this scaffold was added, export JSON files were not committed in this workspace.

## Recommended Workflow
1. Export or copy the latest JSON artifacts into this folder.
2. Record snapshot date/version in `STAGE18_APPLE_REFERENCE_SPEC.md`.
3. Update statuses in `FIGMA_TRANSLATION_CONTRACT.md`.
4. Classify deltas in `STAGE18_FIDELITY_LOG.md` before promotion.
