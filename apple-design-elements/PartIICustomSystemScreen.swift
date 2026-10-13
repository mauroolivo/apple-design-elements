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

            Section("Part II Roadmap") {
                Label("Stage 9 - Themes and environment propagation", systemImage: "paintpalette")
                Label("Stage 10 - Figma translation contract", systemImage: "square.and.pencil")
                Label("Stage 11 - Visual fidelity and regression", systemImage: "photo.on.rectangle")
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
                Text("Model primitive, semantic, and component tokens separately; brand decisions should update reusable UI from one source without rewriting component internals.")
            }
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
