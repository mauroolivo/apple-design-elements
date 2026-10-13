# Figma to SwiftUI Fidelity Checklist

Last updated: 2026-10-13
Stage: 11
Status: Draft v0

## Purpose
Define a repeatable fidelity-validation workflow from inspectable Apple Figma metadata to SwiftUI implementation evidence.

## Reference configuration
- Simulator model: iPhone 18 Pro
- OS: iOS 27.0
- SDK: iPhoneSimulator27.1
- Appearance: Light (baseline), Dark (secondary)
- Dynamic Type: `.large` baseline, one accessibility size stress case
- Locale: `en_US` baseline
- Layout direction: LTR baseline, RTL stress case

## Handoff questions
- Which source is inspected (file name, key, version, date)?
- Is the value from Figma metadata, Figma geometry, Apple docs, or inference?
- Is the value mapped to primitive, semantic, or component token?
- Is the token used in reusable component API or screen-local composition?

## Point/pixel and measurement rules
- Compare layout and typography in points first.
- Record display scale separately for screenshot exports.
- Treat antialiasing/font rasterization differences as expected rendering variance unless they shift geometry.
- Do not classify system dynamic-color adaptation as a regression when semantic roles remain intact.

## Screenshot and comparison workflow
1. Capture SwiftUI implementation screenshot in baseline environment.
2. Export matching reference crop from inspectable source when possible.
3. Align crops by shared anchors (safe area, card edges, baseline text).
4. Compare geometry (padding, spacing, corner radius, border width) before color and blur nuance.
5. Log each discrepancy with classification and owner action.

## Discrepancy classification
- `Implementation bug`: wrong spacing/radius/stroke/layout/typography mapping.
- `Intentional platform adaptation`: documented deviation to preserve native behavior.
- `Documented customization`: product-owned divergence with rationale.
- `Unresolved reference question`: missing/ambiguous source evidence.

## Stage 11 deliberate-delta test
- Introduce 1-3 pt deltas in one specimen (padding, border, radius).
- Detect via visual comparison and measured values.
- Correct token/component source, not one-off per-screen offsets.

## Acceptance criteria
- Token path is traceable for each checked value.
- Baseline geometry deltas are either fixed or explicitly classified.
- Accessibility checks pass for the validated component state.
- Journal contains environment matrix, findings, and follow-up actions.
