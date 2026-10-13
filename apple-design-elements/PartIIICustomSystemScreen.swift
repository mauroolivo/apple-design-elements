import SwiftUI

struct PartIIICustomSystemScreen: View {
    let assumptions: [LabEnvironmentAssumption]

    var body: some View {
        Group {
            Section("Stage 13 Forms & Interactive Controls") {
                FormsAndInteractiveControlsSection()
            }

            Section("Stage 14 Composed Components & Consistency") {
                ComposedComponentsConsistencySection()
            }

            Section("Stage 15 Accessibility as a Design-System Guarantee") {
                AccessibilityGuaranteeSection()
            }

            Section("Part III Roadmap") {
                Label("Stage 16 - Localization, RTL, and content stress scenarios", systemImage: "globe")
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
                Text("Preserve native semantics, compose from shared foundations, and treat accessibility guarantees as release-blocking component contracts.")
            }
        }
    }
}

private struct AccessibilityGuaranteeSection: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor

    @State private var missingSemanticLabel = false
    @State private var colorOnlyStatus = false
    @State private var compactTouchTarget = false

    private var passesContract: Bool {
        !missingSemanticLabel && !colorOnlyStatus && !compactTouchTarget
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AccessibilityEnvironmentMatrixCard(
                dynamicTypeSize: dynamicTypeSize,
                colorSchemeContrast: colorSchemeContrast,
                layoutDirection: layoutDirection,
                reduceMotion: reduceMotion,
                reduceTransparency: reduceTransparency,
                differentiateWithoutColor: differentiateWithoutColor
            )

            Toggle("Simulate missing semantic labels", isOn: $missingSemanticLabel)
            Toggle("Simulate color-only status communication", isOn: $colorOnlyStatus)
            Toggle("Simulate compact tap target", isOn: $compactTouchTarget)

            AccessibilityContractCard(
                missingSemanticLabel: missingSemanticLabel,
                colorOnlyStatus: colorOnlyStatus,
                compactTouchTarget: compactTouchTarget
            )

            if passesContract {
                DSFeedbackBanner(
                    kind: .success,
                    title: "Accessibility contract passes",
                    message: "Semantics, non-color cues, and interaction size remain explicit under current environment settings."
                )
            } else {
                DSFeedbackBanner(
                    kind: .warning,
                    title: "Accessibility contract regression",
                    message: "One or more guarantees are broken. Fix component semantics or token constraints before promoting this variant."
                )
            }

            AccessibilityRegressionComparisonCard(
                missingSemanticLabel: missingSemanticLabel,
                colorOnlyStatus: colorOnlyStatus,
                compactTouchTarget: compactTouchTarget
            )

            Text("Stage 15 rule: treat accessibility as a release-blocking design-system contract, not a post-hoc visual QA checklist.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct AccessibilityEnvironmentMatrixCard: View {
    let dynamicTypeSize: DynamicTypeSize
    let colorSchemeContrast: ColorSchemeContrast
    let layoutDirection: LayoutDirection
    let reduceMotion: Bool
    let reduceTransparency: Bool
    let differentiateWithoutColor: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Accessibility environment snapshot")
                .font(.subheadline.weight(.semibold))

            AccessibilityEnvironmentRow(label: "Dynamic Type", value: dynamicTypeDescription)
            AccessibilityEnvironmentRow(label: "Contrast", value: colorSchemeContrast == .increased ? "Increased" : "Standard")
            AccessibilityEnvironmentRow(label: "Layout direction", value: layoutDirection == .rightToLeft ? "RTL" : "LTR")
            AccessibilityEnvironmentRow(label: "Reduce motion", value: reduceMotion ? "On" : "Off")
            AccessibilityEnvironmentRow(label: "Reduce transparency", value: reduceTransparency ? "On" : "Off")
            AccessibilityEnvironmentRow(label: "Differentiate without color", value: differentiateWithoutColor ? "On" : "Off")
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var dynamicTypeDescription: String {
        switch dynamicTypeSize {
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

private struct AccessibilityEnvironmentRow: View {
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

private struct AccessibilityContractCard: View {
    let missingSemanticLabel: Bool
    let colorOnlyStatus: Bool
    let compactTouchTarget: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Guarantee checklist")
                .font(.subheadline.weight(.semibold))

            AccessibilityCheckRow(
                label: "VoiceOver-readable labels and hints",
                passes: !missingSemanticLabel,
                failureReason: "A key interactive element lost semantic text."
            )
            AccessibilityCheckRow(
                label: "Status communication beyond color",
                passes: !colorOnlyStatus,
                failureReason: "Meaning depends on color without icon/text redundancy."
            )
            AccessibilityCheckRow(
                label: "Minimum touch target and control comfort",
                passes: !compactTouchTarget,
                failureReason: "Interactive target is too small for reliable input."
            )
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
    }
}

private struct AccessibilityCheckRow: View {
    let label: String
    let passes: Bool
    let failureReason: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 8) {
                Image(systemName: passes ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(passes ? .green : .orange)
                Text(label)
                    .font(.footnote)
            }
            if !passes {
                Text(failureReason)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 24)
            }
        }
    }
}

private struct AccessibilityRegressionComparisonCard: View {
    let missingSemanticLabel: Bool
    let colorOnlyStatus: Bool
    let compactTouchTarget: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Comparison: guaranteed contract vs regression")
                .font(.subheadline.weight(.semibold))

            VStack(alignment: .leading, spacing: 8) {
                Label("Guaranteed: DSFeedbackBanner + DSStatusBadge + explicit text", systemImage: "checkmark.circle")
                    .font(.footnote)

                HStack(spacing: 8) {
                    Circle()
                        .fill(colorOnlyStatus ? .orange : .green)
                        .frame(width: 10, height: 10)
                        .accessibilityHidden(true)

                    Text(missingSemanticLabel ? "" : "Regressed sample")
                        .font(.caption)
                        .lineLimit(1)

                    Text("Tap")
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, compactTouchTarget ? 4 : 10)
                        .padding(.vertical, compactTouchTarget ? 3 : 8)
                        .background(Color(uiColor: .tertiarySystemBackground), in: Capsule())
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(missingSemanticLabel ? "" : "Regressed sample")
                .accessibilityHint("Illustrates how missing semantics, color-only cues, or small targets create accessibility risk.")
            }
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct ComposedComponentsConsistencySection: View {
    @State private var showingDetails = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Show detail rows", isOn: $showingDetails)

            DSSectionHeader(
                title: "Library overview",
                subtitle: "Shared foundations reused across cards, rows, headers, badges, and feedback",
                actionTitle: "Refresh",
                action: {}
            )

            DSCard(
                title: "Composed components built from shared primitives",
                subtitle: "The same spacing, text roles, and surface tokens should appear consistently across patterns.",
                footer: "Consistency comes from shared ownership, not from copying values between screens."
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    DSListRow(symbolName: "rectangle.grid.2x2.fill", title: "Cards", subtitle: "Structural containers with content slots", trailingText: "4")
                    if showingDetails {
                        DSListRow(symbolName: "text.alignleft", title: "Section headers", subtitle: "Titles, subtitles, and optional actions", trailingText: "2")
                        DSListRow(symbolName: "bell.badge.fill", title: "Feedback", subtitle: "State banners and status badges", trailingText: "3")
                    }
                    DSListRow(symbolName: "seal.fill", title: "Status badges", subtitle: "Compact semantic indicators", trailingText: "6", showsChevron: true)
                }
            }

            DSFeedbackBanner(
                kind: .info,
                title: "Shared foundation check",
                message: "Cards, rows, and feedback elements should read as one system even when their local jobs differ."
            )

            DSConsistencyComparisonCard()

            Text("Stage 14 rule: keep component-local tokens separate from layout decisions, and compare a tokenized composition against a duplicated-magic-number version before promoting the pattern.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct DSConsistencyComparisonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Comparison: shared foundation vs duplicated numbers")
                .font(.subheadline.weight(.semibold))

            VStack(alignment: .leading, spacing: 6) {
                Text("Shared foundation: one token set for spacing, borders, and surfaces.")
                Text("Duplicated numbers: each screen redefines the same paddings and radii, increasing drift risk.")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                DSStatusBadge(kind: .success, text: "Consistent")
                DSStatusBadge(kind: .warning, text: "Drift risk")
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private enum DSAccountTier: String, CaseIterable, Identifiable {
    case basic = "Basic"
    case plus = "Plus"
    case pro = "Pro"

    var id: String { rawValue }
}

private struct FormsAndInteractiveControlsSection: View {
    @State private var email = ""
    @State private var password = ""
    @State private var referral = ""
    @State private var marketingOptIn = true
    @State private var disableForm = false
    @State private var showValidation = true
    @State private var selectedTier: DSAccountTier = .plus

    private var emailState: DSFieldState {
        disableForm ? .disabled : .normal
    }

    private var passwordState: DSFieldState {
        if disableForm { return .disabled }
        return showValidation && password.count < 8 ? .error : .normal
    }

    private var referralState: DSFieldState {
        disableForm ? .disabled : .normal
    }

    private var canContinue: Bool {
        !disableForm && !email.isEmpty && password.count >= 8
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Disable form", isOn: $disableForm)
            Toggle("Show validation", isOn: $showValidation)

            VStack(alignment: .leading, spacing: 14) {
                Text("Account details")
                    .font(.headline)

                DSField(
                    title: "Email",
                    placeholder: "name@domain.com",
                    text: $email,
                    state: emailState,
                    helperText: "Used for sign-in and product updates.",
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress,
                    submitLabel: .next
                )

                DSField(
                    title: "Password",
                    placeholder: "Enter a password",
                    text: $password,
                    state: passwordState,
                    helperText: showValidation ? nil : "Validation hidden for this scenario.",
                    errorText: "Password must contain at least 8 characters.",
                    isSecure: true,
                    keyboardType: .default,
                    textContentType: .newPassword,
                    submitLabel: .done
                )

                DSField(
                    title: "Referral code",
                    placeholder: "Optional",
                    text: $referral,
                    state: referralState,
                    helperText: "Optional promotion code or invite.",
                    keyboardType: .asciiCapable,
                    submitLabel: .go
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text("Account tier")
                        .font(.footnote.weight(.semibold))
                    Picker("Account tier", selection: $selectedTier) {
                        ForEach(DSAccountTier.allCases) { tier in
                            Text(tier.rawValue).tag(tier)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Toggle("Marketing emails", isOn: $marketingOptIn)

                Text("Grouping note: this card keeps related inputs, selection controls, and the primary action together for easier scanning and validation.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                DSButton(
                    canContinue ? "Continue" : "Fix form to continue",
                    role: .primary,
                    size: .regular,
                    state: canContinue ? .enabled : .disabled,
                    action: {}
                )
                .dsTheme(.ocean)

                Text(formSummary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            FormControlsAntiPatternCard()

            Text("Stage 13 rule: preserve native editing, selection, and focus behavior; use DSField for validation and form grouping rather than rebuilding text input mechanics.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var formSummary: String {
        let emailSummary = email.isEmpty ? "empty" : "filled"
        let optInSummary = marketingOptIn ? "on" : "off"
        return [
            "State: tier=\(selectedTier.rawValue)",
            "email=\(emailSummary)",
            "passwordLength=\(password.count)",
            "optIn=\(optInSummary)"
        ]
        .joined(separator: ", ")
    }
}

private struct FormControlsAntiPatternCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Anti-pattern: fragments spread across unrelated screens")
                .font(.subheadline.weight(.semibold))

            Text("When labels, fields, selection controls, and actions are separated, validation and focus cues are harder to understand and preserve.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview("Part III") {
    List {
        PartIIICustomSystemScreen(assumptions: [
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
