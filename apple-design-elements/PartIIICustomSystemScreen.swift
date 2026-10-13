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

            Section("Stage 16 Localization, RTL, and Content Stress") {
                LocalizationRTLStressSection()
            }

            Section("Stage 17 Motion, Feedback Timing, and Interruption Handling") {
                MotionTimingInterruptionSection()
            }

            Section("Part III Roadmap") {
                Label("Part IV - Stage 18 Apple JSON integration", systemImage: "link")
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
                Text("Preserve native semantics, compose from shared foundations, and enforce accessibility, localization, motion, and interruption contracts before promotion.")
            }
        }
    }
}

private enum Stage17RequestState: String {
    case idle = "Idle"
    case saving = "Saving"
    case success = "Success"
    case failure = "Failure"
    case interrupted = "Interrupted"
}

private struct MotionTimingInterruptionSection: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var requestState: Stage17RequestState = .idle
    @State private var responseOutcomeIsFailure = false
    @State private var simulatedLatencyMs: Double = 700
    @State private var simulateFeedbackFlood = false
    @State private var requestToken = UUID()

    private var timingContractPasses: Bool {
        !simulateFeedbackFlood
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MotionEnvironmentCard(reduceMotion: reduceMotion)

            Toggle("Simulate failure outcome", isOn: $responseOutcomeIsFailure)
            Toggle("Simulate feedback flood anti-pattern", isOn: $simulateFeedbackFlood)

            VStack(alignment: .leading, spacing: 8) {
                Text("Simulated response delay: \(Int(simulatedLatencyMs)) ms")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Slider(value: $simulatedLatencyMs, in: 150...2400, step: 50)
                    .accessibilityLabel("Simulated response delay")
            }

            MotionFeedbackContractCard(
                requestState: requestState,
                simulatedLatencyMs: Int(simulatedLatencyMs),
                simulateFeedbackFlood: simulateFeedbackFlood
            )

            HStack(spacing: 8) {
                DSButton(
                    requestState == .saving ? "Saving..." : "Simulate save",
                    role: .primary,
                    size: .regular,
                    state: requestState == .saving ? .loading : .enabled,
                    action: startSimulatedSave
                )

                DSButton(
                    "Interrupt",
                    role: .secondary,
                    size: .regular,
                    state: requestState == .saving ? .enabled : .disabled,
                    action: interruptCurrentRequest
                )
            }
            .dsTheme(.ocean)

            if simulateFeedbackFlood {
                VStack(alignment: .leading, spacing: 6) {
                    DSFeedbackBanner(kind: .info, title: "Queue event", message: "Request queued.")
                    DSFeedbackBanner(kind: .info, title: "Queue event", message: "Request still queued.")
                    DSFeedbackBanner(kind: .warning, title: "Queue event", message: "Too many overlapping notices reduce clarity.")
                }
            }

            DSFeedbackBanner(
                kind: statusBannerKind,
                title: statusBannerTitle,
                message: statusBannerMessage
            )

            Text("Stage 17 rule: feedback must acknowledge action quickly, communicate progress clearly, and handle interruption without motion-heavy or duplicate-notice noise.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var statusBannerKind: DSFeedbackKind {
        switch requestState {
        case .idle: return .info
        case .saving: return .info
        case .success: return .success
        case .failure: return .critical
        case .interrupted: return .warning
        }
    }

    private var statusBannerTitle: String {
        switch requestState {
        case .idle: return "Awaiting action"
        case .saving: return "In progress"
        case .success: return "Save completed"
        case .failure: return "Save failed"
        case .interrupted: return "Save interrupted"
        }
    }

    private var statusBannerMessage: String {
        switch requestState {
        case .idle:
            return "Start a request to evaluate timing and interruption behavior."
        case .saving:
            return "Progress is visible and cancellation remains available while work is in flight."
        case .success:
            return "Completion feedback appears once without stacking duplicated notices."
        case .failure:
            return "Failure is explicit and should offer a stable retry path."
        case .interrupted:
            return "Interruption is explicit so users understand why completion feedback did not arrive."
        }
    }

    private func startSimulatedSave() {
        let token = UUID()
        requestToken = token
        setState(.saving)

        let nanoseconds = UInt64(simulatedLatencyMs * 1_000_000)
        Task {
            try? await Task.sleep(nanoseconds: nanoseconds)
            guard requestToken == token, requestState == .saving else { return }
            setState(responseOutcomeIsFailure ? .failure : .success)
        }
    }

    private func interruptCurrentRequest() {
        requestToken = UUID()
        setState(.interrupted)
    }

    private func setState(_ newState: Stage17RequestState) {
        if reduceMotion {
            requestState = newState
        } else {
            withAnimation(.easeInOut(duration: 0.2)) {
                requestState = newState
            }
        }
    }
}

private struct MotionEnvironmentCard: View {
    let reduceMotion: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Motion and timing snapshot")
                .font(.subheadline.weight(.semibold))

            AccessibilityEnvironmentRow(label: "Reduce motion", value: reduceMotion ? "On" : "Off")
            AccessibilityEnvironmentRow(label: "Contract focus", value: "Action acknowledgment + progress + interruption")
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct MotionFeedbackContractCard: View {
    let requestState: Stage17RequestState
    let simulatedLatencyMs: Int
    let simulateFeedbackFlood: Bool

    private var quickAcknowledgePasses: Bool {
        requestState == .saving || requestState == .success || requestState == .failure || requestState == .interrupted
    }

    private var progressVisibilityPasses: Bool {
        requestState != .idle
    }

    private var interruptionPasses: Bool {
        requestState != .idle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stage 17 guarantee checklist")
                .font(.subheadline.weight(.semibold))

            AccessibilityCheckRow(
                label: "Action acknowledged quickly",
                passes: quickAcknowledgePasses,
                failureReason: "No immediate state change after interaction."
            )
            AccessibilityCheckRow(
                label: "Progress/terminal state is visible",
                passes: progressVisibilityPasses,
                failureReason: "Users cannot tell whether work is in progress or finished."
            )
            AccessibilityCheckRow(
                label: "Interruption outcome is explicit",
                passes: interruptionPasses,
                failureReason: "Cancellation/override leaves ambiguous status."
            )
            AccessibilityCheckRow(
                label: "Avoid duplicate feedback stacking",
                passes: !simulateFeedbackFlood,
                failureReason: "Overlapping notices create motion and cognitive noise."
            )

            Text("Current state: \(requestState.rawValue), simulated delay: \(simulatedLatencyMs) ms")
                .font(.caption)
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

private enum Stage16LocalePreset: String, CaseIterable, Identifiable {
    case english = "English"
    case german = "German"
    case arabic = "Arabic"
    case pseudo = "Pseudo"

    var id: String { rawValue }

    var sampleTitle: String {
        switch self {
        case .english: return "Account security settings"
        case .german: return "Kontosicherheitseinstellungen"
        case .arabic: return "I3dadat amn alhisab"
        case .pseudo: return "[!! Accoouuntt Seccuurriittyy Settiinnggs !!]"
        }
    }

    var sampleDescription: String {
        switch self {
        case .english: return "Review sign-in methods, active sessions, and recovery options."
        case .german: return "Prufen Sie Anmeldemethoden, aktive Sitzungen und Wiederherstellungsoptionen."
        case .arabic: return "Murajaat turuq tasjil aldukhul waljalsat alnaashita wakhiyaarat alistirjae."
        case .pseudo: return "[!! Reevieew siggn-inn methhoods, actiive sessiions, and recooveery optiions. !!]"
        }
    }

    var actionTitle: String {
        switch self {
        case .english: return "Review"
        case .german: return "Uberprufen"
        case .arabic: return "Murajaa"
        case .pseudo: return "[!! Reevieew Noow !!]"
        }
    }
}

private struct LocalizationRTLStressSection: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.layoutDirection) private var layoutDirection

    @State private var selectedLocale: Stage16LocalePreset = .english
    @State private var forceRTL = false
    @State private var useLongContent = true
    @State private var showTruncationRisk = false

    private var effectiveDirection: LayoutDirection {
        forceRTL ? .rightToLeft : layoutDirection
    }

    private var contentContractPasses: Bool {
        !(showTruncationRisk && useLongContent)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Locale preset", selection: $selectedLocale) {
                ForEach(Stage16LocalePreset.allCases) { preset in
                    Text(preset.rawValue).tag(preset)
                }
            }
            .pickerStyle(.segmented)

            Toggle("Force RTL simulation", isOn: $forceRTL)
            Toggle("Use long localized content", isOn: $useLongContent)
            Toggle("Simulate truncation anti-pattern", isOn: $showTruncationRisk)

            LocalizationEnvironmentCard(
                dynamicTypeSize: dynamicTypeSize,
                effectiveDirection: effectiveDirection,
                selectedLocale: selectedLocale,
                isLongContent: useLongContent
            )

            LocalizationContractPreviewCard(
                selectedLocale: selectedLocale,
                isLongContent: useLongContent,
                showTruncationRisk: showTruncationRisk
            )
            .environment(\.layoutDirection, effectiveDirection)

            DirectionalSymbolContractCard(effectiveDirection: effectiveDirection)
                .environment(\.layoutDirection, effectiveDirection)

            if contentContractPasses {
                DSFeedbackBanner(
                    kind: .success,
                    title: "Localization contract passes",
                    message: "Text expansion, directionality, and action affordances remain understandable under this scenario."
                )
            } else {
                DSFeedbackBanner(
                    kind: .warning,
                    title: "Localization contract regression",
                    message: "Expanded text is being truncated by fixed constraints. Replace brittle width assumptions with adaptive layout."
                )
            }

            Text("Stage 16 rule: every reusable pattern must survive text expansion, RTL direction changes, and pseudo-localized stress content without semantic loss.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct LocalizationEnvironmentCard: View {
    let dynamicTypeSize: DynamicTypeSize
    let effectiveDirection: LayoutDirection
    let selectedLocale: Stage16LocalePreset
    let isLongContent: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Localization stress snapshot")
                .font(.subheadline.weight(.semibold))

            AccessibilityEnvironmentRow(label: "Locale preset", value: selectedLocale.rawValue)
            AccessibilityEnvironmentRow(label: "Direction", value: effectiveDirection == .rightToLeft ? "RTL" : "LTR")
            AccessibilityEnvironmentRow(label: "Dynamic Type", value: dynamicTypeDescription)
            AccessibilityEnvironmentRow(label: "Content mode", value: isLongContent ? "Expanded" : "Compact")
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

private struct LocalizationContractPreviewCard: View {
    let selectedLocale: Stage16LocalePreset
    let isLongContent: Bool
    let showTruncationRisk: Bool

    private var titleText: String {
        selectedLocale.sampleTitle
    }

    private var descriptionText: String {
        if isLongContent {
            return selectedLocale.sampleDescription + " " + selectedLocale.sampleDescription
        }
        return selectedLocale.sampleDescription
    }

    var body: some View {
        DSCard(
            title: "Localized contract specimen",
            subtitle: "Adaptive layout should preserve meaning across locale and text-length variance.",
            footer: "Anti-pattern toggle intentionally applies brittle width and line-limit constraints."
        ) {
            VStack(alignment: .leading, spacing: 10) {
                Text(titleText)
                    .font(.headline)
                    .lineLimit(showTruncationRisk ? 1 : nil)

                Text(descriptionText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(showTruncationRisk ? 2 : nil)

                HStack(spacing: 8) {
                    DSStatusBadge(kind: .info, text: selectedLocale.rawValue)
                    DSButton(selectedLocale.actionTitle, role: .secondary, size: .compact, state: .enabled, action: {})
                }
            }
            .frame(maxWidth: showTruncationRisk ? 250 : .infinity, alignment: .leading)
        }
    }
}

private struct DirectionalSymbolContractCard: View {
    let effectiveDirection: LayoutDirection

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Directional contract check")
                .font(.subheadline.weight(.semibold))

            HStack(spacing: 12) {
                Label("Semantic forward", systemImage: "chevron.forward")
                Label("Fixed right", systemImage: "arrow.right")
            }
            .font(.footnote)

            Text(effectiveDirection == .rightToLeft
                 ? "RTL active: semantic symbols adapt direction automatically; fixed arrows may communicate the wrong flow."
                 : "LTR active: both symbols appear aligned, but semantic variants remain safer for bidirectional support.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
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
