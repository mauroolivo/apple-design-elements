import SwiftUI

struct PartIICustomSystemScreen: View {
    let assumptions: [LabEnvironmentAssumption]

    var body: some View {
        Group {
            Section("Stage 7 Architecture & Ownership") {
                ArchitectureOwnershipSection()
            }

            Section("Stage 8 Token Modeling") {
                TokenModelingSection()
            }

            Section("Stage 9 Themes & Environment Propagation") {
                ThemePropagationSection()
            }

            Section("Stage 10 Figma Translation Contract") {
                FigmaTranslationContractSection()
            }

            Section("Stage 11 Visual Fidelity & Regression") {
                VisualFidelityRegressionSection()
            }

            Section("Stage 12 Component Anatomy & API Design") {
                ComponentAnatomySection()
            }

            Section("Baseline Visual Matrix") {
                ForEach(assumptions) { assumption in
                    HStack(alignment: .firstTextBaseline) {
                        Text(assumption.key)
                            .foregroundStyle(.secondary)
                        Spacer(minLength: 12)
                        Text(assumption.value)
                            .multilineTextAlignment(.trailing)
                    }
                    .accessibilityElement(children: .combine)
                }
            }

            Section("Current Rule") {
                Text("Use typed semantic APIs for reusable components; avoid boolean explosion and preserve native control semantics.")
            }
        }
    }
}

private struct ComponentAnatomySection: View {
    @State private var selectedRole: DSButtonRole = .primary
    @State private var selectedSize: DSButtonSize = .regular
    @State private var selectedState: DSButtonState = .enabled
    @State private var tapCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Role", selection: $selectedRole) {
                ForEach(DSButtonRole.allCases) { role in
                    Text(role.rawValue).tag(role)
                }
            }
            .pickerStyle(.segmented)

            Picker("Size", selection: $selectedSize) {
                ForEach(DSButtonSize.allCases) { size in
                    Text(size.rawValue).tag(size)
                }
            }
            .pickerStyle(.segmented)

            Picker("State", selection: $selectedState) {
                ForEach(DSButtonState.allCases) { state in
                    Text(state.rawValue).tag(state)
                }
            }
            .pickerStyle(.segmented)

            Text("Semantic API-driven DSButton")
                .font(.headline)

            DSButton(
                "Apply changes (\(tapCount))",
                role: selectedRole,
                size: selectedSize,
                state: selectedState,
                action: { tapCount += 1 }
            )
            .dsTheme(.ocean)

            DSButtonAnatomyCard(role: selectedRole, size: selectedSize, state: selectedState)

            Divider()

            Text("Boolean explosion anti-pattern")
                .font(.headline)
            BooleanExplosionAntiPatternCard()

            Text("Stage 12 rule: model reusable components with semantic enums and explicit states; avoid many independent booleans that create invalid combinations.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct DSButtonAnatomyCard: View {
    let role: DSButtonRole
    let size: DSButtonSize
    let state: DSButtonState

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Current contract snapshot")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)

            Text("Role: \(role.rawValue)")
                .font(.footnote)
            Text("Size: \(size.rawValue)")
                .font(.footnote)
            Text("State: \(state.rawValue)")
                .font(.footnote)
            Text("Slots: label (+ optional loading indicator)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
    }
}

private struct BooleanExplosionAntiPatternCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("`isPrimary`, `isSecondary`, `isDanger`, `isLarge`, `isCompact`, `isLoading`, `isDisabled`")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)

            Text("Independent booleans create conflicting states (for example, `isPrimary && isSecondary`) and unclear precedence.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct VisualFidelityRegressionSection: View {
    @State private var introduceMismatch = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FigmaMetadataSnapshotCard()

            Toggle("Introduce 1-3 pt mismatch", isOn: $introduceMismatch)

            Text("Reference vs implementation comparison")
                .font(.headline)

            VStack(alignment: .leading, spacing: 12) {
                FidelityReferenceCard()
                FidelityImplementationCard(isMismatched: introduceMismatch)
            }

            FidelityMeasurementTable(isMismatched: introduceMismatch)

            Text("Classification rule: treat measurable geometry deltas as implementation bugs first; keep dynamic rendering differences in a separate adaptation bucket.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct FigmaMetadataSnapshotCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Inspectable source snapshot")
                .font(.subheadline.weight(.semibold))

            FidelityMetricRow(label: "Kit", value: "iOS and iPadOS 27 (Community)")
            FidelityMetricRow(label: "Pages", value: "46")
            FidelityMetricRow(label: "Components", value: "1506")
            FidelityMetricRow(label: "Component sets", value: "223")
            FidelityMetricRow(label: "Styles", value: "86")

            Text("Counts are captured from `figma-export/file.json` and used as Stage 11 traceability evidence.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct FidelityMetricRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer(minLength: 12)
            Text(value)
                .fontWeight(.medium)
        }
        .font(.footnote)
    }
}

private struct FidelityReferenceCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reference spec (course-authored, traceable)")
                .font(.subheadline.weight(.semibold))
            Text("Padding 16 pt, radius 14 pt, border 1 pt")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("Primary action")
                .font(.footnote.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.blue, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .foregroundStyle(.white)
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
    }
}

private struct FidelityImplementationCard: View {
    let isMismatched: Bool

    private var outerPadding: CGFloat { isMismatched ? 18 : 16 }
    private var cornerRadius: CGFloat { isMismatched ? 13 : 14 }
    private var borderWidth: CGFloat { isMismatched ? 2 : 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Implementation sample")
                .font(.subheadline.weight(.semibold))
            Text(isMismatched ? "Deliberate deltas: +2 pt padding, -1 pt radius, +1 pt border" : "Aligned to reference values")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text("Primary action")
                .font(.footnote.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.blue, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .foregroundStyle(.white)
        }
        .padding(outerPadding)
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: borderWidth)
        )
    }
}

private struct FidelityMeasurementTable: View {
    let isMismatched: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Measured discrepancy log")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)

            FidelityCheckRow(label: "Container padding", expected: "16", actual: isMismatched ? "18" : "16")
            FidelityCheckRow(label: "Corner radius", expected: "14", actual: isMismatched ? "13" : "14")
            FidelityCheckRow(label: "Border width", expected: "1", actual: isMismatched ? "2" : "1")
        }
    }
}

private struct FidelityCheckRow: View {
    let label: String
    let expected: String
    let actual: String

    private var isMatching: Bool { expected == actual }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isMatching ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(isMatching ? .green : .orange)

            Text(label)
                .font(.footnote)

            Spacer(minLength: 8)

            Text("exp \(expected) / act \(actual)")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }
}

private struct FigmaTranslationContractSection: View {
    private let mappings: [FigmaContractMapping] = [
        .init(figmaTarget: "Button / Primary / Container fill", tokenPath: "components.button.background", evidence: "Brand accent semantic action", status: "Provisional"),
        .init(figmaTarget: "Button / Primary / Label color", tokenPath: "components.button.foreground", evidence: "On-accent text role", status: "Provisional"),
        .init(figmaTarget: "Card / Surface fill", tokenPath: "components.card.background", evidence: "Semantic surface primary", status: "Provisional"),
        .init(figmaTarget: "Card / Border", tokenPath: "components.card.border + borderWidth", evidence: "Semantic subtle border", status: "Provisional"),
        .init(figmaTarget: "Badge / Pill background", tokenPath: "components.badge.background", evidence: "Semantic accent surface", status: "Provisional")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FigmaAccessStatusCard()

            Divider()

            Text("Provisional translation table")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(mappings) { mapping in
                    FigmaContractMappingRow(mapping: mapping)
                }
            }

            Divider()

            Text("Readiness gates")
                .font(.headline)
            Label("Do not claim official values without inspectable source metadata", systemImage: "checkmark.circle")
                .font(.footnote)
            Label("Record token path + rationale for every imported value", systemImage: "checkmark.circle")
                .font(.footnote)
            Label("Flag unresolved mappings as provisional until verified", systemImage: "checkmark.circle")
                .font(.footnote)

            Text("Stage 10 rule: translation from design source to code tokens must remain auditable, versioned, and explicit about confidence level.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct FigmaAccessStatusCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Source availability")
                .font(.subheadline.weight(.semibold))
            Label("Metadata exports are available in figma-export/", systemImage: "checkmark.circle")
                .font(.footnote)
            Text("Contract remains provisional for exact measurements until node-level geometry and variable access are fully verified.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
    }
}

private struct FigmaContractMapping: Identifiable {
    let id = UUID()
    let figmaTarget: String
    let tokenPath: String
    let evidence: String
    let status: String
}

private struct FigmaContractMappingRow: View {
    let mapping: FigmaContractMapping

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(mapping.figmaTarget)
                .font(.footnote.weight(.semibold))
            Text("Token: \(mapping.tokenPath)")
                .font(.system(.caption, design: .monospaced))
            Text("Evidence: \(mapping.evidence)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("Status: \(mapping.status)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct ThemePropagationSection: View {
    @State private var brandDecision: DSBrandDecision = .ocean
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Theme brand", selection: $brandDecision) {
                ForEach(DSBrandDecision.allCases) { decision in
                    Text(decision.rawValue).tag(decision)
                }
            }
            .pickerStyle(.segmented)

            ThemeEnvironmentMatrixCard(
                colorScheme: colorScheme,
                colorSchemeContrast: colorSchemeContrast,
                dynamicTypeSize: dynamicTypeSize
            )

            Divider()

            Text("Environment-injected themed components")
                .font(.headline)
            EnvironmentTokenShowcase()
                .dsTheme(brandDecision)

            Divider()

            Text("Prop-drilling anti-pattern")
                .font(.headline)
            PropDrillingAntiPatternCard(brandDecision: brandDecision)

            Text("Stage 9 rule: resolve tokens at the theme boundary and inject through environment values so subtrees consume semantics directly.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct ThemeEnvironmentMatrixCard: View {
    let colorScheme: ColorScheme
    let colorSchemeContrast: ColorSchemeContrast
    let dynamicTypeSize: DynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Resolved environment inputs")
                .font(.subheadline.weight(.semibold))

            ThemeEnvironmentRow(label: "Color scheme", value: colorScheme == .dark ? "Dark" : "Light")
            ThemeEnvironmentRow(label: "Contrast", value: colorSchemeContrast == .increased ? "Increased" : "Standard")
            ThemeEnvironmentRow(label: "Dynamic Type", value: dynamicTypeSize.description)

            Text("These values become theme inputs; tokens should resolve once near the boundary, not repeatedly inside every component.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct ThemeEnvironmentRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer(minLength: 12)
            Text(value)
                .fontWeight(.medium)
        }
        .font(.footnote)
    }
}

private struct EnvironmentTokenShowcase: View {
    @Environment(\.dsTokens) private var tokenBundle

    var body: some View {
        VStack(alignment: .leading, spacing: tokenBundle.semantics.spacing.stack) {
            DSTokenCard(tokenBundle: tokenBundle)

            HStack(spacing: tokenBundle.semantics.spacing.inline) {
                DSTokenBadge(text: "Env-propagated", tokenBundle: tokenBundle)
                DSTokenButton(title: "Themed action", tokenBundle: tokenBundle)
            }
        }
    }
}

private struct PropDrillingAntiPatternCard: View {
    let brandDecision: DSBrandDecision

    var body: some View {
        let tokenBundle = DSTokenBundle.make(for: brandDecision)

        VStack(alignment: .leading, spacing: 8) {
            Text("Manual token threading")
                .font(.subheadline.weight(.semibold))

            Text("`Parent -> Section -> Row -> Leaf(tokenBundle:)` scales poorly because every level receives design data it does not own.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 6) {
                Text("Parent(tokenBundle)")
                Text("  -> MidLevel(tokenBundle)")
                Text("     -> Row(tokenBundle)")
                Text("        -> LeafButton(tokenBundle)")
            }
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(.secondary)

            DSTokenButton(title: "Still works, but tightly coupled", tokenBundle: tokenBundle)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
    }
}

private extension DynamicTypeSize {
    var description: String {
        switch self {
        case .xSmall: return "xSmall"
        case .small: return "small"
        case .medium: return "medium"
        case .large: return "large"
        case .xLarge: return "xLarge"
        case .xxLarge: return "xxLarge"
        case .xxxLarge: return "xxxLarge"
        case .accessibility1: return "accessibility1"
        case .accessibility2: return "accessibility2"
        case .accessibility3: return "accessibility3"
        case .accessibility4: return "accessibility4"
        case .accessibility5: return "accessibility5"
        @unknown default: return "unknown"
        }
    }
}

private struct ArchitectureOwnershipSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current dependency graph")
                .font(.headline)
            DependencyGraphCard()

            Divider()

            Text("Package-now vs package-later decision")
                .font(.headline)
            PackagingDecisionCard()

            Divider()

            Text("Minimal public API proposal")
                .font(.headline)
            PublicAPIProposalCard()

            Text("Rule: avoid a giant `Theme` object or protocol-per-token architecture until we prove repeated call sites and ownership pressure.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct DependencyGraphCard: View {
    private let graph = [
        "App Target (DesignSystemLab)",
        "  |- Stage specimen views",
        "  |- Local semantic decisions (documented)",
        "  `- Apple frameworks (SwiftUI/UIKit semantics)"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Single-module baseline")
                .font(.subheadline.weight(.semibold))

            ForEach(graph, id: \.self) { line in
                Text(line)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.secondary)
            }

            Text("No package boundary yet: current coupling is low and iteration speed is high.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct PackagingDecisionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Decision: stay in app target for Stage 7")
                .font(.subheadline.weight(.semibold))

            Label("Pros now: fast iteration, lower ceremony, direct preview context", systemImage: "checkmark.circle")
                .font(.footnote)
            Label("Cons now: weaker boundary enforcement and reuse signaling", systemImage: "exclamationmark.circle")
                .font(.footnote)
            Label("Escalation trigger: repeated cross-file tokens/components + unstable call sites", systemImage: "arrow.up.circle")
                .font(.footnote)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
        .foregroundStyle(.secondary)
    }
}

private struct PublicAPIProposalCard: View {
    private let proposedAPIs = [
        "Foundations",
        "- DSColorRole",
        "- DSTextRole",
        "- DSSpacing",
        "",
        "Components",
        "- DSButton(role:size:state:)",
        "- DSField(state:)",
        "- DSCard(style:)"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Small, stable surface")
                .font(.subheadline.weight(.semibold))

            ForEach(proposedAPIs, id: \.self) { line in
                Text(line)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.secondary)
            }

            Text("These are naming targets only for governance decisions in Stage 7; implementation remains local until Stage 8+ token modeling pressure appears.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct TokenModelingSection: View {
    @State private var brandDecision: DSBrandDecision = .ocean

    private var tokenBundle: DSTokenBundle {
        .make(for: brandDecision)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Brand decision", selection: $brandDecision) {
                ForEach(DSBrandDecision.allCases) { decision in
                    Text(decision.rawValue).tag(decision)
                }
            }
            .pickerStyle(.segmented)

            TokenPipelineCard(tokenBundle: tokenBundle)

            Divider()

            Text("Tokenized components update together")
                .font(.headline)
            TokenizedComponentShowcase(tokenBundle: tokenBundle)

            Divider()

            Text("Magic-number anti-pattern")
                .font(.headline)
            MagicNumberAntiPatternCard()

            Text("Experiment: switch the brand decision above. The button and card update from one token source; the hard-coded anti-pattern does not.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct TokenPipelineCard: View {
    let tokenBundle: DSTokenBundle

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Primitive → semantic → component")
                .font(.subheadline.weight(.semibold))

            TokenRow(
                title: "Primitive",
                detail: "brand.accent / spacing.md / radius.card",
                swatch: tokenBundle.primitives.brand.accent
            )
            TokenRow(
                title: "Semantic",
                detail: "actionPrimary / surfaceAccent / textMuted",
                swatch: tokenBundle.semantics.actions.primary
            )
            TokenRow(
                title: "Component",
                detail: "DSButton.background / DSCard.badgeBackground",
                swatch: tokenBundle.components.button.background
            )

            Text("System-derived semantics remain allowed inside semantic tokens (`Color.primary`, `separator`, `secondarySystemBackground`) so product tokens don't replace platform behavior unnecessarily.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct TokenRow: View {
    let title: String
    let detail: String
    let swatch: Color

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(swatch)
                .frame(width: 24, height: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(Color(uiColor: .separator), lineWidth: 0.5)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.footnote.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct TokenizedComponentShowcase: View {
    let tokenBundle: DSTokenBundle

    var body: some View {
        VStack(alignment: .leading, spacing: tokenBundle.semantics.spacing.stack) {
            DSTokenCard(tokenBundle: tokenBundle)

            HStack(spacing: tokenBundle.semantics.spacing.inline) {
                DSTokenBadge(text: tokenBundle.primitives.brand.name, tokenBundle: tokenBundle)
                DSTokenButton(title: "Continue", tokenBundle: tokenBundle)
            }
        }
    }
}

private struct DSTokenCard: View {
    let tokenBundle: DSTokenBundle

    var body: some View {
        VStack(alignment: .leading, spacing: tokenBundle.semantics.spacing.stack) {
            HStack {
                Text("Tokenized card")
                    .font(.headline)
                    .foregroundStyle(tokenBundle.semantics.text.primary)
                Spacer()
                DSTokenBadge(text: "Semantic", tokenBundle: tokenBundle)
            }

            Text("This surface and action styling update from one brand decision without editing component internals.")
                .font(.subheadline)
                .foregroundStyle(tokenBundle.semantics.text.muted)

            DSTokenButton(title: "Primary action", tokenBundle: tokenBundle)
        }
        .padding(tokenBundle.components.card.padding)
        .background(tokenBundle.components.card.background, in: RoundedRectangle(cornerRadius: tokenBundle.components.card.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: tokenBundle.components.card.cornerRadius, style: .continuous)
                .stroke(tokenBundle.components.card.border, lineWidth: tokenBundle.components.card.borderWidth)
        )
    }
}

private struct DSTokenButton: View {
    let title: String
    let tokenBundle: DSTokenBundle

    var body: some View {
        Text(title)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(tokenBundle.components.button.foreground)
            .padding(.horizontal, tokenBundle.components.button.horizontalPadding)
            .padding(.vertical, tokenBundle.components.button.verticalPadding)
            .background(tokenBundle.components.button.background, in: RoundedRectangle(cornerRadius: tokenBundle.components.button.cornerRadius, style: .continuous))
    }
}

private struct DSTokenBadge: View {
    let text: String
    let tokenBundle: DSTokenBundle

    var body: some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(tokenBundle.components.badge.foreground)
            .padding(.horizontal, tokenBundle.components.badge.horizontalPadding)
            .padding(.vertical, tokenBundle.components.badge.verticalPadding)
            .background(tokenBundle.components.badge.background, in: Capsule())
    }
}

private struct MagicNumberAntiPatternCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hard-coded style island")
                .font(.headline)
                .foregroundStyle(Color(red: 0.95, green: 0.97, blue: 1.0))

            Text("These values do not respond to the brand picker because the component owns raw values directly instead of semantic tokens.")
                .font(.subheadline)
                .foregroundStyle(Color(red: 0.77, green: 0.84, blue: 0.93))

            Text("Fixed action")
                .font(.footnote.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color(red: 0.12, green: 0.25, blue: 0.55), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .foregroundStyle(.white)
        }
        .padding(16)
        .background(Color(red: 0.08, green: 0.14, blue: 0.24), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(red: 0.18, green: 0.31, blue: 0.54), lineWidth: 1)
        )
    }
}
