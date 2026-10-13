import SwiftUI

enum DSFeedbackKind: String, CaseIterable, Identifiable {
    case info = "Info"
    case success = "Success"
    case warning = "Warning"
    case critical = "Critical"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .critical: return "xmark.octagon.fill"
        }
    }

    var tint: Color {
        switch self {
        case .info: return .blue
        case .success: return .green
        case .warning: return .orange
        case .critical: return .red
        }
    }

    var background: Color {
        switch self {
        case .info: return .blue.opacity(0.10)
        case .success: return .green.opacity(0.10)
        case .warning: return .orange.opacity(0.12)
        case .critical: return .red.opacity(0.10)
        }
    }
}

struct DSCard<Content: View>: View {
    let title: String?
    let subtitle: String?
    let footer: String?
    @ViewBuilder let content: () -> Content

    @Environment(\.dsTokenBundle) private var tokenBundle

    init(
        title: String? = nil,
        subtitle: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.footer = footer
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: tokenBundle.semantics.spacing.stack) {
            if title != nil || subtitle != nil {
                VStack(alignment: .leading, spacing: 4) {
                    if let title {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(tokenBundle.semantics.text.primary)
                    }
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(tokenBundle.semantics.text.muted)
                    }
                }
            }

            content()

            if let footer {
                Text(footer)
                    .font(.footnote)
                    .foregroundStyle(tokenBundle.semantics.text.muted)
            }
        }
        .padding(tokenBundle.components.card.padding)
        .background(tokenBundle.components.card.background, in: RoundedRectangle(cornerRadius: tokenBundle.components.card.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: tokenBundle.components.card.cornerRadius, style: .continuous)
                .stroke(tokenBundle.components.card.border, lineWidth: tokenBundle.components.card.borderWidth)
        )
    }
}

struct DSSectionHeader: View {
    let title: String
    let subtitle: String?
    let actionTitle: String?
    let action: (() -> Void)?

    @Environment(\.dsTokenBundle) private var tokenBundle

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: tokenBundle.semantics.spacing.inline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(tokenBundle.semantics.text.primary)

                if let subtitle {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(tokenBundle.semantics.text.muted)
                }
            }

            Spacer(minLength: 8)

            if let actionTitle, let action {
                DSButton(actionTitle, role: .secondary, size: .compact, state: .enabled, action: action)
            }
        }
    }
}

struct DSListRow: View {
    let symbolName: String
    let title: String
    let subtitle: String?
    let trailingText: String?
    var showsChevron: Bool = false

    @Environment(\.dsTokenBundle) private var tokenBundle

    var body: some View {
        HStack(alignment: .top, spacing: tokenBundle.semantics.spacing.inline) {
            Image(systemName: symbolName)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(tokenBundle.semantics.actions.primary)
                .frame(width: 24, height: 24)
                .background(tokenBundle.semantics.surfaces.accent.opacity(0.55), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(tokenBundle.semantics.text.primary)
                    .lineLimit(1)

                if let subtitle {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(tokenBundle.semantics.text.muted)
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 8)

            if let trailingText {
                Text(trailingText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tokenBundle.semantics.text.muted)
            }

            if showsChevron {
                Image(systemName: "chevron.forward")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tokenBundle.semantics.text.muted)
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}

struct DSStatusBadge: View {
    let kind: DSFeedbackKind
    let text: String

    var body: some View {
        Label(text, systemImage: kind.symbolName)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(kind.background, in: Capsule())
            .foregroundStyle(kind.tint)
            .accessibilityLabel(text)
            .accessibilityHint(kind.rawValue)
    }
}

struct DSFeedbackBanner: View {
    let kind: DSFeedbackKind
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    @Environment(\.dsTokenBundle) private var tokenBundle

    var body: some View {
        VStack(alignment: .leading, spacing: tokenBundle.semantics.spacing.inline) {
            HStack(alignment: .top, spacing: tokenBundle.semantics.spacing.inline) {
                Image(systemName: kind.symbolName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(kind.tint)
                    .frame(width: 24, height: 24)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(tokenBundle.semantics.text.primary)

                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(tokenBundle.semantics.text.muted)
                }

                Spacer(minLength: 8)

                DSStatusBadge(kind: kind, text: kind.rawValue)
            }

            if let actionTitle, let action {
                DSButton(actionTitle, role: .secondary, size: .compact, state: .enabled, action: action)
            }
        }
        .padding()
        .background(kind.background, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(kind.tint.opacity(0.35), lineWidth: 1)
        )
    }
}

#Preview("Composed Components Matrix") {
    VStack(alignment: .leading, spacing: 16) {
        DSSectionHeader(
            title: "Project overview",
            subtitle: "Shared foundations expressed through reusable component contracts",
            actionTitle: "See all",
            action: {}
        )

        DSCard(title: "Design system cards", subtitle: "Longer content and mixed text styles") {
            VStack(alignment: .leading, spacing: 8) {
                DSListRow(symbolName: "circle.grid.3x3.fill", title: "Tokens", subtitle: "Primitive and semantic layers", trailingText: "12")
                DSListRow(symbolName: "square.stack.3d.up.fill", title: "Components", subtitle: "Card, row, badge, and feedback", trailingText: "4", showsChevron: true)
                DSListRow(symbolName: "accessibility", title: "Accessibility", subtitle: "Dynamic Type and focus semantics", trailingText: "Pass")
            }
        }

        DSFeedbackBanner(
            kind: .success,
            title: "Build verified",
            message: "The shared component foundations compile and preserve native interaction contracts.",
            actionTitle: "Review",
            action: {}
        )

        HStack(spacing: 8) {
            DSStatusBadge(kind: .info, text: "Info")
            DSStatusBadge(kind: .warning, text: "Warning")
            DSStatusBadge(kind: .critical, text: "Critical")
        }
    }
    .padding()
    .dsTheme(.ocean)
}
