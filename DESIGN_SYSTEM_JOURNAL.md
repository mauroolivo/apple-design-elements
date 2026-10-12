# Design System Journal

This journal captures stage-by-stage evidence for the `DesignSystemLab` learning project.

---

## Stage 0 - Establish the design-system laboratory

Date: 2026-10-10

### Goal and design-system mental model
Establish a small, repeatable laboratory environment where Apple-native baseline behavior is observable before introducing custom design-system ownership.

### Apple baseline / reference behavior
- Existing app baseline: single SwiftUI screen with default system typography, symbol rendering, spacing, and container behavior.
- Initial Stage 0 UI now uses native `NavigationStack`, `List`, and `Section` as baseline system-owned primitives.
- No custom theme engine, no custom token graph, no custom control library introduced.

### Design question and prediction
- Question: Can we define a reliable visual baseline matrix without inventing token values or pre-building architecture?
- Prediction: Yes. A minimal showcase with explicit environment assumptions will reveal where evidence is missing and prevent premature abstraction.

### Minimal hands-on implementation
- Replaced placeholder `ContentView` with a lightweight `DesignSystemLab` entry screen in `apple-design-elements/ContentView.swift`.
- Added `APPLE_REFERENCE_INVENTORY.md` to track official Apple sources, kit availability, and licensing constraints.
- Created this `DESIGN_SYSTEM_JOURNAL.md` as a stage-by-stage evidence log.

### Figma/reference comparison or visual inspection
- Official Apple Figma candidate identified from Apple Design Resources: iOS and iPadOS 27 UI Kit.
- Figma is not inspectable in this environment at this time (no file/session/export provided).
- Therefore all values in Stage 0 are from documented Apple sources or explicit environment observation, not Figma measurements.

### Accessibility and adaptation checks
- Baseline screen uses native semantic structures (`List`, `Section`, `Label`) that inherit Dynamic Type and accessibility behavior.
- No custom contrast/motion/transparency overrides introduced in Stage 0.
- Assumed locale and layout direction are documented as assumptions pending explicit simulator verification.

### Trade-offs and design-system rule
- Trade-off: We prioritize traceability and environment control over visual ambition in Stage 0.
- Rule: Never claim precision beyond inspectable evidence; mark assumptions explicitly and resolve them in controlled captures.

### Journal entry
Observed via local CLI inspection:
- Xcode: 27.1 (27A9269)
- Swift toolchain: Apple Swift 6.4 (`swiftlang-6.4.0.34.1`)
- Project target Swift language mode: `SWIFT_VERSION = 5.0`
- Deployment target: `IPHONEOS_DEPLOYMENT_TARGET = 27.0`
- Default actor isolation: `MainActor`
- Approachable concurrency: enabled
- Verified simulator availability includes iOS 27.0 `iPhone 18 Pro`
- App build for iOS simulator succeeded

Baseline visual test matrix:
- Device: iPhone 18 Pro simulator
- OS: iOS 27.0
- SDK used to build: iPhoneSimulator27.1
- Display scale: pending capture verification
- Interface style: Light (target baseline)
- Dynamic Type: Default (`.large`)
- Locale: `en_US` (assumed, pending verification)
- Layout direction: LTR (assumed, pending verification)
- Content state: initial app launch, no user data

Screenshot status:
- Capture attempt was initiated but skipped in this run.
- Required follow-up: capture baseline screenshot and record file path plus exact simulator settings.

---

## Stage 1 - Apple's design principles and semantic system

Date: 2026-10-10

### Goal and design-system mental model
Build a first customization policy grounded in Apple principles: keep system semantics as default ownership and only customize where product meaning improves.

### Apple baseline / reference behavior
- Source used: HIG Design Principles (`Purpose`, `Familiarity`, `Flexibility`, `Simplicity`, `Craft`).
- Source used: HIG Components index (system components as default familiarity surface).
- Source used: HIG Accessibility (Dynamic Type, contrast, control sizing, alternatives to gesture-only behavior).

### Design question and prediction
- Question: Which UI decisions should remain system-owned vs become product-owned in this laboratory?
- Prediction: Interaction semantics, accessibility adaptation, and common control behavior should remain system-owned; brand expression should target tone, composition, and selective visual accents.

### Minimal hands-on implementation
- Extended `apple-design-elements/ContentView.swift` with a Stage 1 comparison section:
  - `AppleNativeExampleCard`: native typography, material, and `Button` style.
  - `BrandHeavyExampleCard`: intentionally flawed anti-pattern (fixed tiny type, weak contrast relationships, undersized tap target).
- Added a short rule in the UI: "Prefer native semantics first; customize only where brand or product intent requires ownership."

### Figma/reference comparison or visual inspection
- No inspectable Figma source available.
- Comparison performed as Apple-documented-semantics baseline vs intentionally over-customized mockup.
- All measurements in this stage are course-authored for analysis, not claimed as Apple kit values.

### Accessibility and adaptation checks
- Native card inherits Dynamic Type and semantic contrast behavior with minimal code.
- Flawed card intentionally violates likely readability and touch-comfort expectations, and uses hard-coded sizes/colors that are brittle under accessibility settings.
- Stage implication: customization policy must protect system accessibility guarantees as non-negotiable defaults.

### Trade-offs and design-system rule
- Trade-off: Brand-heavy visuals can create immediate differentiation but increase long-term maintenance and accessibility risk.
- Rule: Start with system semantics for typography, controls, and interaction states; introduce brand overrides only when they preserve adaptation and materially improve product meaning.

### Journal entry
Stage 1 customization policy draft (v0):
1. Keep navigation structure, control semantics, and state feedback system-owned unless a product requirement cannot be met otherwise.
2. Treat typography and color as semantic first; avoid fixed raw values in reusable components unless justified by measured need.
3. Any custom component must document accessibility parity targets before visual polish work.
4. "Looks branded" is insufficient justification for replacing native behavior.

Evidence classification for this stage:
- Documented: HIG principles/accessibility/components pages.
- Observed: behavior differences between native and brand-heavy cards in local showcase code.
- Inferred: risk level of brittle fixed-size, low-adaptability styling.

### Stop and wait for `next`
Stage 1 is complete. Continue only after receiving `next`.

---

## Stage 2 - Typography as a system

Date: 2026-10-10

### Goal and design-system mental model
Establish typography as semantic behavior, not isolated visual styling: text styles encode hierarchy, Dynamic Type encodes adaptation, and custom ramps require explicit scaling contracts.

### Apple baseline / reference behavior
- Source used: HIG Typography (legibility guidance, Dynamic Type support expectations, hierarchy rules).
- Source used: SwiftUI `DynamicTypeSize` and `ScaledMetric` documentation for adaptive text and layout values.
- Source used: UIKit `UIFontMetrics` documentation as the baseline mechanism for scaling custom fonts in UIKit contexts.

### Design question and prediction
- Question: Can we build a custom type ramp that preserves Dynamic Type behavior while keeping hierarchy intent explicit?
- Prediction: Yes, if custom sizes are scaled relative to semantic anchors and verified at accessibility sizes; no, if fixed-point sizes are used directly in reusable components.

### Minimal hands-on implementation
- Added a Stage 2 section in `apple-design-elements/ContentView.swift` with a typography specimen:
  - `SemanticStylesSpecimen` shows Apple semantic styles (`largeTitle` through `caption`).
  - `CustomRampSpecimen` uses `@ScaledMetric(relativeTo: .body)` to scale custom base sizes proportionally.
  - `FixedRampAntiPatternSpecimen` deliberately uses fixed sizes to demonstrate a failure mode.
- Added preview coverage for default and `.accessibility3` Dynamic Type categories.

### Figma/reference comparison or visual inspection
- No inspectable official Apple Figma file is available.
- Stage 2 uses Apple-documented typography semantics and a course-authored custom ramp.
- Any numeric values in the custom ramp are laboratory decisions, not Apple-kit claims.

### Accessibility and adaptation checks
- Semantic styles scale automatically and maintain relative hierarchy at larger text sizes.
- The custom ramp scales with Dynamic Type through `@ScaledMetric`, including non-text values (icon side) tied to text growth.
- The fixed ramp remains static and illustrates readability/regression risk at accessibility categories.

### Trade-offs and design-system rule
- Trade-off: fixed typography can enforce brand precision at one size but breaks accessibility and cross-context robustness.
- Rule: typography APIs in reusable components must be semantic or explicitly Dynamic Type-scaled; fixed point sizes are only acceptable for tightly bounded decorative text with documented exceptions.

### Journal entry
Stage 2 decisions:
1. Keep Apple semantic text styles as first choice for product UI hierarchy.
2. If introducing custom typography, scale from semantic anchors using `@ScaledMetric` (SwiftUI) or `UIFontMetrics` (UIKit boundaries).
3. Treat text + spacing/icon scale as one accessibility contract, not separate polish decisions.
4. Never assume custom typography can transparently replace every system text style globally in SwiftUI.

Verification:
- Local build after Stage 2 changes succeeded for iOS simulator target (`iPhone 18 Pro`, iOS 27.0).
- Dynamic Type behavior inspected through default and `.accessibility3` previews.

### Stop and wait for `next`
Stage 2 is complete. Continue only after receiving `next`.


---

## Stage 3 - System colors, semantic roles, and appearance

Date: 2026-10-12

### Goal and design-system mental model
Treat color as semantic behavior owned primarily by the system: design-system customization should describe role intent, not hard-code appearance that breaks under environment changes.

### Apple baseline / reference behavior
- Source used: HIG Color guidance for semantic roles and contrast-aware adaptation.
- Source used: SwiftUI `Color` semantics (`.primary`, `.secondary`, tint) and UIKit dynamic element colors.
- Source used: SwiftUI contrast environment documentation to define how increased-contrast checks should be executed during simulator validation.

### Design question and prediction
- Question: Can semantic color roles preserve legibility and hierarchy across appearance/contrast changes better than fixed RGB values?
- Prediction: Yes. Semantic roles should adapt automatically, while fixed palettes will produce brittle contrast and hierarchy in at least one environment.

### Minimal hands-on implementation
- Added a Stage 3 section in `apple-design-elements/ContentView.swift`:
  - `AppleSemanticColorCard`: semantic foreground/background and separator usage.
  - `HardCodedColorAntiPatternCard`: intentionally fixed palette values.
  - `SemanticSwatch` helper for side-by-side role inspection.
- Added `Dark Mode` preview variant to expose semantic adaptation quickly.
- Kept increased-contrast validation as a simulator-settings check in the visual matrix workflow.
- Updated the visible lab rule to include semantic color ownership.

### Figma/reference comparison or visual inspection
- No inspectable official Apple Figma file is available in this workspace.
- Stage 3 uses Apple-documented color semantics and a course-authored anti-pattern comparison.
- No numeric color values are attributed to Apple kit measurements.

### Accessibility and adaptation checks
- Semantic card adapts in dark mode and remains tied to system-managed role relationships.
- Hard-coded card intentionally risks poor contrast and visual hierarchy drift under dark mode/increased contrast.
- Stage implication: custom color APIs must encode semantic role intent and define contrast expectations.

### Trade-offs and design-system rule
- Trade-off: fixed brand color precision can speed one-shot visual matching but increases fragility across system appearance/accessibility changes.
- Rule: reusable components should consume semantic color roles first; raw RGB values require documented scope, rationale, and accessibility verification.

### Journal entry
Stage 3 decisions:
1. Keep semantic text/background/separator roles as baseline component inputs.
2. Wrap product brand color decisions in semantic token names, not raw numeric names.
3. Treat contrast mode and appearance adaptation as acceptance criteria, not optional QA.
4. Prevent one-off color constants from entering reusable components without an explicit exception record.

Verification:
- Local build after Stage 3 changes succeeded for iOS simulator target (`iPhone 18 Pro`, iOS 27.0).
- Visual checks available through default, accessibility-size, and `Dark Mode` previews.
- Increased-contrast validation remains part of simulator configuration checks.

### Stop and wait for `next`
Stage 3 is complete. Continue only after receiving `next`.


---

## Stage 4 - Materials, surfaces, depth, and visual hierarchy

Date: 2026-10-12

### Goal and design-system mental model
Treat material and depth as behavioral context signals, not static decoration: system materials should remain the default substrate for layered UI, while branded surfaces are constrained extensions.

### Apple baseline / reference behavior
- Source used: HIG guidance for translucency/blur and layered visual hierarchy.
- Source used: SwiftUI `Material` semantics and shape-scoped background APIs.
- Source used: UIKit `UIVisualEffectView` docs as the boundary reference for blur behavior outside pure SwiftUI.

### Design question and prediction
- Question: Does platform material preserve depth/legibility across appearance contexts better than a custom fixed blur stack?
- Prediction: Yes. System material should remain resilient under light/dark and scrolling context changes, while hard-coded blur/opacity layers will drift and require fragile tuning.

### Minimal hands-on implementation
- Added a Stage 4 section in `apple-design-elements/ContentView.swift`:
  - `AppleMaterialSurfaceCard`: contextual gradient backdrop + system material surface and separator-aware border.
  - `MaterialChip`: quick sample of multiple material thicknesses (`ultraThin`, `regular`, `thick`).
  - `FragileCustomSurfaceCard`: intentionally brittle faux-glass stack using fixed opacity/blur/shadow values.
- Updated the current lab rule to include system materials as first-class defaults.

### Figma/reference comparison or visual inspection
- No inspectable official Apple Figma file is available in this workspace.
- Stage 4 remains Apple-doc-grounded with course-authored comparative specimens.
- No material radius/opacity/blur value is claimed as an official Apple kit measurement.

### Accessibility and adaptation checks
- Material baseline remains semantically integrated with system foreground/background behavior.
- Custom blur stack intentionally demonstrates risk under appearance and transparency preference changes.
- Increased-contrast and reduced-transparency remain required simulator-level checks in the visual matrix workflow.

### Trade-offs and design-system rule
- Trade-off: bespoke blur stacks can offer strong brand signatures in one context but introduce high adaptation and maintenance cost.
- Rule: prefer system materials for reusable surfaces; branded depth effects must define fallback behavior and pass accessibility environment checks before reuse.

### Journal entry
Stage 4 decisions:
1. Use system materials as the default abstraction for layered surfaces.
2. Encode brand surfaces semantically, not as one-off blur recipes.
3. Require reduced-transparency and contrast fallback notes for non-system surface treatments.
4. Treat depth hierarchy as interaction clarity, not visual-only styling.

Verification:
- Local build after Stage 4 changes succeeded for iOS simulator target (`iPhone 18 Pro`, iOS 27.0).
- Visual checks available through default, accessibility-size, and dark-mode previews.

### Stop and wait for `next`
Stage 4 is complete. Continue only after receiving `next`.


---

## Stage 5 - Apple controls and behavioral contracts

Date: 2026-10-12

### Goal and design-system mental model
Treat controls as behavioral contracts first: native controls carry semantics, accessibility, and platform evolution that custom visuals should preserve by default.

### Apple baseline / reference behavior
- Source used: HIG controls guidance for component expectations and familiar interaction models.
- Source used: SwiftUI `Button`, `ButtonStyle`, and `ControlSize` APIs for native customization boundaries.
- Source used: SwiftUI `Toggle` for state-driven behavior checks inside the lab.

### Design question and prediction
- Question: How much customization can we apply while retaining native behavior, and what breaks when we replace controls with visual look-alikes?
- Prediction: Native control styling preserves semantics with minimal risk; custom look-alikes require manual parity work and are easy to under-specify.

### Minimal hands-on implementation
- Added Stage 5 section in `apple-design-elements/ContentView.swift`:
  - `NativeButtonContractCard`: styled native `Button` with disabled state and control sizing.
  - `CustomButtonContractCard`: intentionally risky custom look-alike using `onTapGesture`.
  - `ControlBehaviorChecklist`: explicit inventory of behaviors required when replacing native controls.
- Added a shared toggle to disable both actions and reveal behavior differences.

### Figma/reference comparison or visual inspection
- No inspectable official Apple Figma file is available in this workspace.
- Stage 5 compares Apple-native behavioral semantics against a course-authored custom control anti-pattern.
- No control metrics are attributed to Apple kit measurements.

### Accessibility and adaptation checks
- Native button keeps accessibility traits and disabled-state semantics automatically.
- Custom look-alike is intentionally incomplete and demonstrates semantic debt risk.
- Stage implication: custom controls must prove VoiceOver, focus, and state parity before reuse approval.

### Trade-offs and design-system rule
- Trade-off: full custom controls can unlock distinct branding, but behavior parity cost is high and easy to underestimate.
- Rule: style native controls first; replace only with evidence-backed need and a written parity checklist covering semantics, states, and accessibility.

### Journal entry
Stage 5 decisions:
1. Native controls remain default for reusable interactions unless a requirement is not achievable via styling/composition.
2. Custom control APIs must include explicit state modeling (pressed, disabled, focus, role).
3. Accessibility parity is an acceptance gate, not a post-hoc fix.
4. Behavior checklists become required documentation for any control replacement proposal.

Verification:
- Local build after Stage 5 changes succeeded for iOS simulator target (`iPhone 18 Pro`, iOS 27.0).
- Visual/behavior checks available through default, accessibility-size, and dark-mode previews.

### Stop and wait for `next`
Stage 5 is complete. Continue only after receiving `next`.


---

## Stage 6 - Iconography, SF Symbols, assets, and imagery

Date: 2026-10-12

### Goal and design-system mental model
Treat iconography as semantic communication tied to platform behavior: symbols should adapt with typography, direction, and rendering context before custom icon sets are introduced.

### Apple baseline / reference behavior
- Source used: HIG icons guidance and platform iconography conventions.
- Source used: SF Symbols official resources for variants and rendering behaviors.
- Source used: SwiftUI `Image`, `Label`, and `SymbolRenderingMode` APIs for practical implementation boundaries.

### Design question and prediction
- Question: Where do SF Symbols cover system needs, and which behaviors are easy to break with custom or hard-coded icon treatment?
- Prediction: SF Symbols handle most semantic/control contexts reliably; fixed-size/resizable misuse and absolute-direction arrows are common failure modes.

### Minimal hands-on implementation
- Added Stage 6 section in `apple-design-elements/ContentView.swift`:
  - `SymbolRenderingModesCard`: monochrome, hierarchical, and palette symbol rendering comparison.
  - `SymbolAlignmentCard`: symbol-text pairing baseline plus a deliberate resizable anti-pattern.
  - `RTLSymbolComparisonCard`: semantic directional symbol (`chevron.forward`) vs fixed absolute arrow (`arrow.right`).
  - `CourseCreatedBadgeIcon`: course-created vector-like icon shape to compare custom icon integration behavior.

### Figma/reference comparison or visual inspection
- No inspectable official Apple Figma file is available in this workspace.
- Stage 6 is grounded in Apple docs/resources and course-authored icon comparison specimens.
- No icon metrics are attributed to Apple kit measurements.

### Accessibility and adaptation checks
- `Label`-based symbol usage preserves icon+text semantics and trait composition by default.
- Symbol rendering modes keep icon meaning while adapting visual treatment semantically.
- Directional semantics (`forward`) are preferred over absolute arrow directions in RTL-sensitive flows.

### Trade-offs and design-system rule
- Trade-off: custom icons increase brand uniqueness, but they require explicit scaling/tint/RTL governance and maintenance effort.
- Rule: choose SF Symbols first for product UI; adopt custom icons only for missing domain meaning and document adaptation contracts.

### Journal entry
Stage 6 decisions:
1. SF Symbols remain the default iconography layer for reusable components.
2. Symbol sizing in text contexts should be font-driven, not arbitrary frame-driven, unless documented exception applies.
3. Direction-aware symbols are required in navigation/action affordances that must support RTL.
4. Custom icons require explicit semantic naming and adaptation checks before entering shared APIs.

Verification:
- Local build after Stage 6 changes succeeded for iOS simulator target (`iPhone 18 Pro`, iOS 27.0).
- Visual checks available through default, accessibility-size, and dark-mode previews.

### Stop and wait for `next`
Stage 6 is complete. Continue only after receiving `next`.
