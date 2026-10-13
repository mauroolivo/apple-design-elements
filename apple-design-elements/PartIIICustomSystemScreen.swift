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

            Section("Part III Roadmap") {
                Label("Stage 15 - Accessibility as a design-system guarantee", systemImage: "accessibility")
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
                Text("Preserve native editing semantics, then compose cards, rows, headers, badges, and feedback from shared foundations.")
            }
        }
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
