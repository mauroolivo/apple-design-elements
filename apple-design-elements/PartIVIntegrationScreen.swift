import SwiftUI

struct PartIVIntegrationScreen: View {
    let assumptions: [LabEnvironmentAssumption]

    var body: some View {
        Group {
            Section("Stage 18 Apple JSON Integration") {
                Stage18AppleJSONIntegrationSection()
            }

            Section("Part IV Deliverables") {
                Stage18DeliverablesSection()
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
                Text("Source metadata and mapping confidence must be explicit before visual-correction changes are allowed.")
            }
        }
    }
}

private enum Stage18IntegrationStep: String, CaseIterable, Identifiable {
    case inventory = "1. JSON inventory"
    case mapping = "2. Token and component mapping"
    case nativeBaseline = "3. Native baseline composition"
    case brandedVariant = "4. Branded custom-system composition"
    case fidelityLog = "5. Fidelity log and correction plan"

    var id: String { rawValue }

    var summary: String {
        switch self {
        case .inventory:
            return "Capture inspectable source metadata first so imported values can be traced later."
        case .mapping:
            return "Map source node identities to code token paths and mark each mapping status."
        case .nativeBaseline:
            return "Build a native semantic specimen before customization to preserve behavior contracts."
        case .brandedVariant:
            return "Layer owned expression through tokens without redefining platform behavior by default."
        case .fidelityLog:
            return "Classify each delta before editing tokens: bug, adaptation, customization, or unresolved reference."
        }
    }

    var checklist: [String] {
        switch self {
        case .inventory:
            return [
                "Attach source artifact metadata (file/version/date).",
                "Capture page/component names and stable node identifiers.",
                "Mark blocked extraction paths explicitly."
            ]
        case .mapping:
            return [
                "Record token destination path in code.",
                "Add rationale for semantic ownership.",
                "Set confidence to Provisional or Verified."
            ]
        case .nativeBaseline:
            return [
                "Use native controls and semantic typography.",
                "Preserve accessibility traits and disabled states.",
                "Treat this as control behavior baseline."
            ]
        case .brandedVariant:
            return [
                "Apply brand through tokenized surfaces/actions.",
                "Keep interactions aligned with native expectations.",
                "Document intentional visual differences."
            ]
        case .fidelityLog:
            return [
                "Measure geometry and spacing deltas.",
                "Classify each mismatch with owner + action.",
                "Gate promotion until unresolved items are closed."
            ]
        }
    }
}

private enum Stage18MappingStatus: String, CaseIterable, Identifiable {
    case provisional = "Provisional"
    case verified = "Verified"

    var id: String { rawValue }
}

private struct Stage18MappingSeed: Identifiable {
    let id = UUID()
    let sourceTarget: String
    let tokenPath: String
    let status: Stage18MappingStatus
}

private struct Stage18AppleJSONIntegrationSection: View {
    @State private var selectedStep: Stage18IntegrationStep = .inventory
    @State private var showRegression = true

    private let seedRows: [Stage18MappingSeed] = [
        .init(sourceTarget: "Button / Primary / Container fill", tokenPath: "components.button.background", status: .provisional),
        .init(sourceTarget: "Button / Primary / Label color", tokenPath: "components.button.foreground", status: .provisional),
        .init(sourceTarget: "Text Field / Surface", tokenPath: "semantics.surfaces.primary", status: .provisional),
        .init(sourceTarget: "Segmented Control / Active emphasis", tokenPath: "semantics.actions.primary", status: .provisional)
    ]

    private var unresolvedCount: Int {
        seedRows.filter { $0.status == .provisional }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Stage18JSONSnapshotCard()

            Picker("Integration step", selection: $selectedStep) {
                ForEach(Stage18IntegrationStep.allCases) { step in
                    Text(step.rawValue).tag(step)
                }
            }
            .pickerStyle(.navigationLink)

            Stage18StepChecklistCard(step: selectedStep)
            Stage18StepDetailsCard(step: selectedStep)

            Toggle("Simulate unresolved fidelity regressions", isOn: $showRegression)

            Stage18MappingSeedTableCard(seedRows: seedRows)

            if showRegression {
                DSFeedbackBanner(
                    kind: .warning,
                    title: "Promotion blocked",
                    message: "\(unresolvedCount) mappings are still provisional. Keep values traceable and classify mismatches before token promotion."
                )
            } else {
                DSFeedbackBanner(
                    kind: .success,
                    title: "Promotion criteria satisfied",
                    message: "Mappings are traceable, adaptation checks pass, and fidelity deltas are classified with owners."
                )
            }

            Text("Stage 18 rule: move from source metadata to token decisions through an explicit workflow; do not patch visuals without provenance and classification.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct Stage18JSONSnapshotCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Source snapshot")
                .font(.subheadline.weight(.semibold))

            Stage18MetricRow(label: "Export artifact", value: "figma-export/file.json")
            Stage18MetricRow(label: "Stage status", value: "Provisional, metadata-inspectable")
            Stage18MetricRow(label: "Blocked extraction", value: "variables_local.json (partial 403)")

            Text("The JSON export is sufficient for auditable mapping seeds even when exact variable-backed values remain incomplete.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct Stage18MetricRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer(minLength: 8)
            Text(value)
                .fontWeight(.medium)
        }
        .font(.footnote)
    }
}

private struct Stage18StepChecklistCard: View {
    let step: Stage18IntegrationStep

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step checklist")
                .font(.subheadline.weight(.semibold))

            ForEach(step.checklist, id: \.self) { item in
                Label(item, systemImage: "checkmark.circle")
                    .font(.footnote)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
    }
}

private struct Stage18StepDetailsCard: View {
    let step: Stage18IntegrationStep

    var body: some View {
        DSCard(
            title: step.rawValue,
            subtitle: step.summary,
            footer: "Keep each output traceable so design-system ownership and correction decisions stay auditable."
        ) {
            VStack(alignment: .leading, spacing: 8) {
                DSListRow(symbolName: "doc.text.magnifyingglass", title: "Input", subtitle: inputDescription, trailingText: "Required")
                DSListRow(symbolName: "arrow.triangle.branch", title: "Output", subtitle: outputDescription, trailingText: "Recorded")
                DSListRow(symbolName: "shield.checkered", title: "Gate", subtitle: gateDescription, trailingText: "Must pass")
            }
        }
    }

    private var inputDescription: String {
        switch step {
        case .inventory:
            return "Inspectable export metadata and source version context."
        case .mapping:
            return "Source target names and node IDs."
        case .nativeBaseline:
            return "Uncustomized semantic composition with native controls."
        case .brandedVariant:
            return "Tokenized brand decision and approved expression rules."
        case .fidelityLog:
            return "Measured deltas across reference and implementation."
        }
    }

    private var outputDescription: String {
        switch step {
        case .inventory:
            return "Inventory table with explicit blocked extraction notes."
        case .mapping:
            return "Token paths with confidence tags and rationale."
        case .nativeBaseline:
            return "Baseline specimen preserving default behavior contracts."
        case .brandedVariant:
            return "Variant specimen with owned visual expression."
        case .fidelityLog:
            return "Classified discrepancy log with correction owners."
        }
    }

    private var gateDescription: String {
        switch step {
        case .inventory:
            return "No source import without metadata traceability."
        case .mapping:
            return "Unknown mappings remain provisional."
        case .nativeBaseline:
            return "Accessibility semantics preserved before customization."
        case .brandedVariant:
            return "Behavior parity expectations documented."
        case .fidelityLog:
            return "Promotion blocked while unresolved deltas remain."
        }
    }
}

private struct Stage18MappingSeedTableCard: View {
    let seedRows: [Stage18MappingSeed]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stage 18 mapping seeds")
                .font(.subheadline.weight(.semibold))

            ForEach(seedRows) { row in
                VStack(alignment: .leading, spacing: 2) {
                    Text(row.sourceTarget)
                        .font(.footnote.weight(.semibold))
                    Text("Token: \(row.tokenPath)")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                    DSStatusBadge(
                        kind: row.status == .verified ? .success : .warning,
                        text: row.status.rawValue
                    )
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
    }
}

private struct Stage18DeliverablesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("`STAGE18_APPLE_REFERENCE_SPEC.md` prepared from selected subset", systemImage: "doc.plaintext")
            Label("`STAGE18_FIDELITY_LOG.md` captures classified deltas", systemImage: "doc.text.magnifyingglass")
            Label("Provisional mappings stay flagged until source verification clears", systemImage: "flag")

            Text("Promotion criteria: semantic ownership is clear, token usage is traceable, metadata is attached, adaptation checks pass, and baseline differences are intentional.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
}

#Preview("Part IV") {
    List {
        PartIVIntegrationScreen(assumptions: [
            .init(key: "Simulator model", value: "iPhone 18 Pro"),
            .init(key: "Simulator OS", value: "iOS 27.0"),
            .init(key: "SDK used to build", value: "iPhoneSimulator27.1"),
            .init(key: "Color scheme", value: "Light"),
            .init(key: "Dynamic Type", value: "Default (.large)"),
            .init(key: "Locale", value: "en_US (assumed; verify in simulator)"),
            .init(key: "Layout direction", value: "Left-to-right (assumed)")
        ])
    }
}
