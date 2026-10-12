import SwiftUI

struct PartIICustomSystemScreen: View {
    let assumptions: [LabEnvironmentAssumption]

    var body: some View {
        Group {
            Section("Stage 7 Architecture & Ownership") {
                ArchitectureOwnershipSection()
            }

            Section("Part II Roadmap") {
                Label("Stage 8 - Token modeling (primitive -> semantic -> component)", systemImage: "point.3.connected.trianglepath.dotted")
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
                Text("Architecture grows only when ownership boundaries become clearer than local app code; extract stable token/component APIs only with repeated evidence.")
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
