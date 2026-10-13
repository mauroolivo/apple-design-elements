import SwiftUI

enum DSButtonRole: String, CaseIterable, Identifiable {
    case primary = "Primary"
    case secondary = "Secondary"
    case destructive = "Destructive"

    var id: String { rawValue }
}

enum DSButtonSize: String, CaseIterable, Identifiable {
    case compact = "Compact"
    case regular = "Regular"
    case large = "Large"

    var id: String { rawValue }
}

enum DSButtonState: String, CaseIterable, Identifiable {
    case enabled = "Enabled"
    case disabled = "Disabled"
    case loading = "Loading"

    var id: String { rawValue }
}

struct DSButton<Label: View>: View {
    private let role: DSButtonRole
    private let size: DSButtonSize
    private let state: DSButtonState
    private let action: () -> Void
    private let label: Label

    @Environment(\.dsTokenBundle) private var tokenBundle

    init(
        role: DSButtonRole = .primary,
        size: DSButtonSize = .regular,
        state: DSButtonState = .enabled,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.role = role
        self.size = size
        self.state = state
        self.action = action
        self.label = label()
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: tokenBundle.semantics.spacing.inline) {
                if state == .loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(size.progressControlSize)
                }

                label
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .disabled(state != .enabled)
        .buttonStyle(
            DSButtonVisualStyle(
                role: role,
                size: size,
                state: state,
                tokenBundle: tokenBundle
            )
        )
        .accessibilityValue(Text(state.rawValue))
    }
}

extension DSButton where Label == Text {
    init(
        _ title: String,
        role: DSButtonRole = .primary,
        size: DSButtonSize = .regular,
        state: DSButtonState = .enabled,
        action: @escaping () -> Void
    ) {
        self.init(role: role, size: size, state: state, action: action) {
            Text(title)
        }
    }
}

private struct DSButtonVisualStyle: ButtonStyle {
    let role: DSButtonRole
    let size: DSButtonSize
    let state: DSButtonState
    let tokenBundle: DSTokenBundle

    func makeBody(configuration: Configuration) -> some View {
        let visual = resolvedVisual(isPressed: configuration.isPressed)

        return configuration.label
            .font(size.font)
            .foregroundStyle(visual.foreground)
            .padding(.horizontal, size.horizontalPadding(base: tokenBundle.components.button.horizontalPadding))
            .padding(.vertical, size.verticalPadding(base: tokenBundle.components.button.verticalPadding))
            .background(
                RoundedRectangle(cornerRadius: tokenBundle.components.button.cornerRadius, style: .continuous)
                    .fill(visual.background)
            )
            .overlay(
                RoundedRectangle(cornerRadius: tokenBundle.components.button.cornerRadius, style: .continuous)
                    .stroke(visual.border, lineWidth: visual.borderWidth)
            )
            .opacity(state == .disabled ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }

    private func resolvedVisual(isPressed: Bool) -> DSButtonResolvedVisual {
        switch role {
        case .primary:
            let bg: Color
            if state == .disabled {
                bg = tokenBundle.semantics.actions.primary.opacity(0.55)
            } else if isPressed {
                bg = tokenBundle.semantics.actions.pressed
            } else {
                bg = tokenBundle.semantics.actions.primary
            }

            return DSButtonResolvedVisual(
                background: bg,
                foreground: tokenBundle.components.button.foreground,
                border: .clear,
                borderWidth: 0
            )
        case .secondary:
            return DSButtonResolvedVisual(
                background: Color(uiColor: .secondarySystemBackground),
                foreground: tokenBundle.semantics.text.primary,
                border: tokenBundle.semantics.borders.subtle,
                borderWidth: tokenBundle.semantics.borders.width
            )
        case .destructive:
            return DSButtonResolvedVisual(
                background: isPressed ? Color.red.opacity(0.78) : Color.red,
                foreground: .white,
                border: .clear,
                borderWidth: 0
            )
        }
    }
}

private struct DSButtonResolvedVisual {
    let background: Color
    let foreground: Color
    let border: Color
    let borderWidth: CGFloat
}

private extension DSButtonSize {
    var font: Font {
        switch self {
        case .compact:
            return .footnote.weight(.semibold)
        case .regular:
            return .body.weight(.semibold)
        case .large:
            return .headline
        }
    }

    func horizontalPadding(base: CGFloat) -> CGFloat {
        switch self {
        case .compact:
            return max(10, base - 3)
        case .regular:
            return base
        case .large:
            return base + 4
        }
    }

    func verticalPadding(base: CGFloat) -> CGFloat {
        switch self {
        case .compact:
            return max(7, base - 2)
        case .regular:
            return base
        case .large:
            return base + 3
        }
    }

    var progressControlSize: ControlSize {
        switch self {
        case .compact:
            return .mini
        case .regular:
            return .small
        case .large:
            return .regular
        }
    }
}

#Preview("DSButton Matrix") {
    VStack(spacing: 12) {
        DSButton("Primary", role: .primary, size: .regular, state: .enabled, action: {})
        DSButton("Secondary", role: .secondary, size: .regular, state: .enabled, action: {})
        DSButton("Destructive", role: .destructive, size: .regular, state: .enabled, action: {})
        DSButton("Loading", role: .primary, size: .regular, state: .loading, action: {})
        DSButton("Disabled", role: .primary, size: .regular, state: .disabled, action: {})
    }
    .padding()
    .dsTheme(.ocean)
}
